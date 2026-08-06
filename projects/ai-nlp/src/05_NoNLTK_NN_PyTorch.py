# NO NLTK: Neural Network classifier (PyTorch) + tokenization + simple lemmatization
import os, re
import pandas as pd
from collections import Counter

import torch
import torch.nn as nn
from torch.utils.data import Dataset, DataLoader
from sklearn.model_selection import train_test_split

DATA_PATH = os.path.join(os.path.dirname(__file__), "IMDB_dataset-1.csv")
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"

def simple_tokenize(text: str):
    text = re.sub(r"<.*?>", " ", str(text))
    text = text.lower()
    return re.findall(r"[a-z]+(?:'[a-z]+)?", text)

IRREGULAR = {
    "better": "good", "best": "good",
    "worse": "bad", "worst": "bad",
    "was": "be", "were": "be", "is": "be", "are": "be", "am": "be", "been": "be",
    "went": "go", "gone": "go",
}

def simple_lemmatize(tok: str) -> str:
    if tok in IRREGULAR:
        return IRREGULAR[tok]
    if tok.endswith("ies") and len(tok) > 4:
        return tok[:-3] + "y"
    if tok.endswith("es") and len(tok) > 3:
        return tok[:-2]
    if tok.endswith("s") and len(tok) > 3 and not tok.endswith("ss"):
        return tok[:-1]
    if tok.endswith("ing") and len(tok) > 5:
        return tok[:-3]
    if tok.endswith("ed") and len(tok) > 4:
        return tok[:-2]
    return tok

def preprocess(text: str):
    return [simple_lemmatize(t) for t in simple_tokenize(text)]

df = pd.read_csv(DATA_PATH)
X = df["review"].astype(str).tolist()
y = df["sentiment"].map({"negative": 0, "positive": 1}).astype(int).tolist()

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

counter = Counter()
for txt in X_train:
    counter.update(preprocess(txt))

MIN_FREQ = 3
vocab = {"<UNK>": 0}
for w, f in counter.items():
    if f >= MIN_FREQ:
        vocab[w] = len(vocab)

def encode(text: str):
    toks = preprocess(text)
    return [vocab.get(t, 0) for t in toks]

class TextDataset(Dataset):
    def __init__(self, texts, labels):
        self.texts = texts
        self.labels = labels
    def __len__(self): return len(self.texts)
    def __getitem__(self, idx): return encode(self.texts[idx]), self.labels[idx]

def collate_batch(batch):
    all_tokens = []
    offsets = [0]
    labels = []
    for tokens, label in batch:
        all_tokens.extend(tokens)
        offsets.append(len(all_tokens))
        labels.append(label)
    offsets = offsets[:-1]
    return (
        torch.tensor(all_tokens, dtype=torch.long),
        torch.tensor(offsets, dtype=torch.long),
        torch.tensor(labels, dtype=torch.float32),
    )

train_loader = DataLoader(TextDataset(X_train, y_train), batch_size=64, shuffle=True, collate_fn=collate_batch)
test_loader  = DataLoader(TextDataset(X_test, y_test), batch_size=64, shuffle=False, collate_fn=collate_batch)

class SentimentNN(nn.Module):
    def __init__(self, vocab_size, embed_dim=64):
        super().__init__()
        self.emb = nn.EmbeddingBag(vocab_size, embed_dim, mode="mean")
        self.fc = nn.Linear(embed_dim, 1)
    def forward(self, tokens, offsets):
        x = self.emb(tokens, offsets)
        return self.fc(x).squeeze(1)

model = SentimentNN(len(vocab), 64).to(DEVICE)
opt = torch.optim.Adam(model.parameters(), lr=1e-3)
loss_fn = nn.BCEWithLogitsLoss()

EPOCHS = 3
for epoch in range(1, EPOCHS + 1):
    model.train()
    total_loss = 0.0
    for tokens, offsets, labels in train_loader:
        tokens, offsets, labels = tokens.to(DEVICE), offsets.to(DEVICE), labels.to(DEVICE)
        opt.zero_grad()
        logits = model(tokens, offsets)
        loss = loss_fn(logits, labels)
        loss.backward()
        opt.step()
        total_loss += loss.detach().item()
    print(f"Epoch {epoch}/{EPOCHS} - train loss = {total_loss/len(train_loader):.4f}")

model.eval()
correct, total = 0, 0
with torch.no_grad():
    for tokens, offsets, labels in test_loader:
        tokens, offsets, labels = tokens.to(DEVICE), offsets.to(DEVICE), labels.to(DEVICE)
        probs = torch.sigmoid(model(tokens, offsets))
        preds = (probs >= 0.5).float()
        correct += int((preds == labels).sum().item())
        total += int(labels.numel())
print("Test accuracy =", correct / total)

comments = [
    "Tom Hanks is incredible here—this movie made me smile the whole time.",
    "Netflix wasted my time; the plot is boring and the acting is awful.",
    "The scenes in New York look great, but the story is messy and confusing.",
    "A beautiful love story set in Paris with strong performances and a satisfying ending."
]

def predict_comment(text: str):
    ids = encode(text)
    if not ids: ids = [0]
    tokens = torch.tensor(ids, dtype=torch.long).to(DEVICE)
    offsets = torch.tensor([0], dtype=torch.long).to(DEVICE)
    with torch.no_grad():
        prob = torch.sigmoid(model(tokens, offsets)[0]).item()
    return prob, ("positive" if prob >= 0.5 else "negative")

for c in comments:
    p, lab = predict_comment(c)
    print("\nComment:", c)
    print("P(positive) =", p)
    print("Prediction  =", lab)