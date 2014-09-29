require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pry'


url = "http://www.rt.com/news"
page = Nokogiri::HTML(open(url))

headline = []
summary = []
url = []

#headline
page.css("dt").each do |dt|
	headline << dt.text
end

#summary
page.css("dd").each do |dd|
	summary << dd.text
end
summary.shift

# url issue with first url is just a, not a.header
url = page.css('a.header').map { |link| link['href'] }



(0..summary.length - 1).each do |index|
	puts "headline: #{headline[index]}"
	puts "description : #{summary[index]}"
	puts "link : #{url[index]}\n"  
end

# (0..dd.length - 1).each do |article|
# 	Russia.create(headline: [])
# end

CSV.open("rt.csv", "wb") do |row|
	row << ["dt", "dd", "link"]
	(0..summary.length - 1).each do |index|
		row << [headline[index], summary[index], url[index]]
	end
end


