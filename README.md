# corenlp-ner

Detecting Cities in Turkey with Stanford NER (Named Entity Recognition)

Firstly, [Stanford NER](https://nlp.stanford.edu/software/CRF-NER.html) requires Java v1.8+

### 1. Download the Stanford NER and extract to project folder

```bash
$ curl -O https://nlp.stanford.edu/software/stanford-ner-2018-02-27.zip
$ unzip stanford-ner-2018-02-27.zip
```

### 2. Create and Test Classifier

```bash
$ ruby ruby-city-ner.rb
```