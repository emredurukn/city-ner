require 'open-uri'
require 'nokogiri'

user_agent = ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3080.30 Safari/537.36", "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.62 Safari/537.36", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36", "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0"]
cities_of_turkey = []

# url opened with open-uri then web page parsed with nokogiri
document = open("http://www.gorkemunel.com/ppc-dosyalari/turkiye-illeri-listesi/", 'User-Agent' => user_agent[rand(4)])
parsed_content = Nokogiri::HTML(document.read, nil, "UTF-8")

# is there any city name in the text?
def is_city?(text, cities)
    flag = false

    cities.each do |city|
        if text.include?(city)
            flag = true
        end
    end

    flag
end

parsed_content.css(".clearfix.entry-content p").first.inner_html.split("<br>").each_with_index do |line, i|
    if i > 0
        # numbers removed from text with regex and gsub then leading and trailing whitespace removed from text with strip
        cities_of_turkey[i-1] = line.gsub(/\d+/,"").strip
    end
end

document = open("http://www.bilgibiriktir.com/2017/06/02/turkiyenin-en-kalabalik-10-sehri/", 'User-Agent' => user_agent[rand(4)])
parsed_content = Nokogiri::HTML(document.read, nil, "UTF-8")

# the information necessary to create the data set is filtered and written to the file in accordance with a template
# according to this template, each word in the line should be labeled in a format like “word\tLABEL”
parsed_content.css(".entry-content").inner_html.split("<p>").each do |line|
    line.split("<img")[0].gsub("<br>","").gsub("</p>","").gsub("."," ").split(" ").each do |word|
        if is_city?(word, cities_of_turkey)
            File.open("corpus.tsv", 'a') { |file| file.write(word.to_s + "\tcity\n") }
        else
            File.open("corpus.tsv", 'a') { |file| file.write(word.to_s + "\t0\n") }
        end
    end
end

%x{
    java -mx1000m -cp stanford-ner-2018-02-27/stanford-ner.jar edu.stanford.nlp.ie.crf.CRFClassifier -prop classifier.prop
}

input = "Roma ve Bizans döneminin en önemli kentlerinden biri olan Konya 1980 sonrası Anadolu kaplanlarının en çok geliştiği vilayetlerden biri olmuştur."

File.open("input.txt", 'w') { |file| file.write(input) }

# output format --> slashTags , inlineXML , xml , tsv, tabbedEntities
%x{
    java -mx500m -cp stanford-ner-2018-02-27/stanford-ner.jar edu.stanford.nlp.ie.crf.CRFClassifier -loadClassifier city-classifier.ser.gz -textFile input.txt -outputFormat inlineXML >> output.txt
}