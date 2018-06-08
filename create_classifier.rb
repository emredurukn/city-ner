require 'open-uri'
require 'nokogiri'

user_agent = ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3080.30 Safari/537.36", "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.62 Safari/537.36", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36", "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0"]
document = open("http://www.gorkemunel.com/ppc-dosyalari/turkiye-illeri-listesi/", 'User-Agent' => user_agent[rand(4)])
parsed_content = Nokogiri::HTML(document.read, nil, "UTF-8")
cities_of_turkey = []

def is_city?(text, city)
    flag = false

    city.each do |ems|
        if text.include?(ems)
            flag = true
        end
    end

    flag
end

parsed_content.css(".clearfix.entry-content p").first.inner_html.split("<br>").each_with_index do |ems, i|
    if i > 0
        cities_of_turkey[i-1] = ems.gsub(/\d+/,"").strip
    end
end

document = open("http://www.bilgibiriktir.com/2017/06/02/turkiyenin-en-kalabalik-10-sehri/", 'User-Agent' => user_agent[rand(4)])
parsed_content = Nokogiri::HTML(document.read, nil, "UTF-8")

parsed_content.css(".entry-content").inner_html.split("<p>").each_with_index do |ems, i|
    ems.split("<img")[0].gsub("<br>","").gsub("</p>","").gsub("."," ").split(" ").each_with_index do |ems2, j|
        if is_city?(ems2, cities_of_turkey)
            File.open("corpus.tsv", 'a') { |file| file.write(ems2.to_s + "\tcity\n") }
        else
            File.open("corpus.tsv", 'a') { |file| file.write(ems2.to_s + "\t0\n") }
        end
    end
end

def create_classifier(properties_file, java_parameter)
    %x{
        java #{java_parameter} -cp stanford-ner-2018-02-27/stanford-ner.jar edu.stanford.nlp.ie.crf.CRFClassifier -prop #{properties_file}
    }
end

create_classifier("classifier.prop", "-mx1000m")
