# corenlp-ner

Detecting Cities in Turkey with Stanford NER (Named Entity Recognizer)

Firstly, [Stanford NER](https://nlp.stanford.edu/software/CRF-NER.html) requires Java v1.8+

### 1. Download the Stanford NER and extract to project folder

```bash
$ curl -O https://nlp.stanford.edu/software/stanford-ner-2018-02-27.zip
$ unzip stanford-ner-2018-02-27.zip
```

### 2. Create Classifier

```bash
$ ruby create_classifier.rb
```

### 3. Test Classifier with input

```bash
$ ruby get_response.rb
```