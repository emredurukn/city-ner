

# output format --> slashTags , inlineXML , xml , tsv, tabbedEntities
def get_response(input_file, java_parameter, classifier_name, output_format, output_file)
    %x{
        java #{java_parameter} -cp stanford-ner-2018-02-27/stanford-ner.jar edu.stanford.nlp.ie.crf.CRFClassifier -loadClassifier #{classifier_name} -textFile #{input_file} -outputFormat #{output_format} >> #{output_file}
    }
end


get_response("input.txt", "-mx500m", "city-classifier.ser.gz", "inlineXML", "response.txt")