# Definitions (Tokenization, Lemmatization, POS Tagging, NER)

## 1) Tokenization
**Definition:** Splitting raw text into smaller units (tokens) such as words and punctuation so a program/model can process it.
**Examples:**
- "I loved it!" → ["I", "loved", "it", "!"]
- "New York is huge." → ["New", "York", "is", "huge", "."]
- "Tom's acting was great." → ["Tom", "'s", "acting", "was", "great", "."]

## 2) Lemmatization
**Definition:** Converting a word to its dictionary/base form (lemma) using linguistic rules (e.g., "running" → "run").
**Examples:**
- "running" → "run"
- "better" → "good"
- "studies" → "study"

## 3) POS Tagging (Part-of-Speech Tagging)
**Definition:** Assigning a grammatical label to each token (noun, verb, adjective, etc.) based on context.
**Examples:**
- "This/DT movie/NN rocks/VBZ ./."
- "I/PRP love/VBP Paris/NNP ./."
- "Amazing/JJ acting/NN today/NN !/."

## 4) Named Entity Recognition (NER)
**Definition:** Detecting and labeling spans of text that refer to named entities (PERSON, ORGANIZATION, LOCATION, etc.).
**Examples:**
- "Tom Hanks" → PERSON
- "Netflix" → ORGANIZATION
- "New York" → GPE/LOCATION