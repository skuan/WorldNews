require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pry'


url = "http://www.nytimes.com/pages/world/index.html"
page = Nokogiri::HTML(open(url))

headline = []
# dd = []
link = []


page.css("div#mostEmailed ol a").each do |title|
	headline << title.text
end

# page.css("dd").each do |description|
# 	dd << description.text
# end

link = page.css('div#mostEmailed ol a').map { |link| link['href'] }

(0..headline.length - 1).each do |index|
	puts "headline: #{headline[index]}"
	# puts "description : #{dd[index]}"
	puts "link : #{link[index]}\n"  
end

CSV.open("nyt.csv", "wb") do |row|
	row << ["headline", "link"]
	(0..headline.length - 1).each do |index|
		row << [headline[index], link[index]]
	end
end