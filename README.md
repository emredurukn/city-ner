# corenlp-ner

Detecting Cities in Turkey with Stanford NER

Firstly, Stanford NER requires Java v1.8+

## 1. Download the Stanford Named Entity Recognizer (NER)

```bash
curl -O https://nlp.stanford.edu/software/stanford-ner-2018-02-27.zip
unzip stanford-ner-2018-02-27.zip
```

## 2. Create Classifier

```bash
ruby create_classifier.rb
```

## 3. Test Classifier with input

```bash
ruby get_response.rb
```