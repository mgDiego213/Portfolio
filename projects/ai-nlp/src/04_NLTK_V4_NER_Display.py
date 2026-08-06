# V4: Tokenization + Lemmatization + NER DISPLAY (NLTK)
import os, re
import pandas as pd


import nltk

def ensure_nltk():
    # Download required resources (quietly). Newer NLTK versions may require *_tab/*_eng packages.
    pkgs = [
        "punkt", "punkt_tab",
        "stopwords",
        "wordnet", "omw-1.4",
        "averaged_perceptron_tagger", "averaged_perceptron_tagger_eng",
        "maxent_ne_chunker", "maxent_ne_chunker_tab",
        "words"
    ]
    for p in pkgs:
        try:
            nltk.download(p, quiet=True)
        except Exception:
            pass

ensure_nltk()

from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords, wordnet
from nltk import pos_tag, ne_chunk
from nltk.stem import WordNetLemmatizer

from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression

DATA_PATH = os.path.join(os.path.dirname(__file__), "IMDB_dataset-1.csv")
STOP_WORDS = set(stopwords.words("english"))
LEMM = WordNetLemmatizer()

def clean_html(text: str) -> str:
    return re.sub(r"<.*?>", " ", str(text))

def to_wordnet_pos(treebank_tag: str):
    if treebank_tag.startswith("J"): return wordnet.ADJ
    if treebank_tag.startswith("V"): return wordnet.VERB
    if treebank_tag.startswith("N"): return wordnet.NOUN
    if treebank_tag.startswith("R"): return wordnet.ADV
    return wordnet.NOUN

def tokenize_for_model(text: str):
    text = clean_html(text).lower()
    text = re.sub(r"[^a-z\s']", " ", text)
    tokens = word_tokenize(text)
    tokens = [t for t in tokens if t not in STOP_WORDS and len(t) > 1]
    tagged = pos_tag(tokens)
    return [LEMM.lemmatize(tok, to_wordnet_pos(tag)) for tok, tag in tagged]

def extract_entities(ne_tree):
    out = []
    for node in ne_tree:
        if hasattr(node, "label"):
            out.append((" ".join([leaf[0] for leaf in node.leaves()]), node.label()))
    return out

def main():
    df = pd.read_csv(DATA_PATH)
    X = df["review"].astype(str)
    y = df["sentiment"].map({"negative": 0, "positive": 1})

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )

    vectorizer = TfidfVectorizer(
        tokenizer=tokenize_for_model,
        preprocessor=None,
        token_pattern=None
    )

    X_train_vec = vectorizer.fit_transform(X_train)
    X_test_vec = vectorizer.transform(X_test)

    model = LogisticRegression(max_iter=2000)
    model.fit(X_train_vec, y_train)

    comments = [
        "Tom Hanks is incredible here—this movie made me smile the whole time.",
        "Netflix wasted my time; the plot is boring and the acting is awful.",
        "The scenes in New York look great, but the story is messy and confusing.",
        "A beautiful love story set in Paris with strong performances and a satisfying ending."
    ]

    for c in comments:
        cleaned = re.sub(r"<.*?>", " ", c)
        cleaned = re.sub(r"[^a-zA-Z\s']", " ", cleaned)
        tokens = word_tokenize(cleaned)
        tagged = pos_tag(tokens)
        tree = ne_chunk(tagged)
        entities = extract_entities(tree)

        print("\n============================")
        print("Comment:", c)
        print("Entities (text, label):")
        print(entities)

        vec = vectorizer.transform([c])
        p_pos = model.predict_proba(vec)[0, 1]
        print("P(positive) =", float(p_pos))
        print("Prediction  =", "positive" if p_pos >= 0.5 else "negative")

if __name__ == "__main__":
    main()