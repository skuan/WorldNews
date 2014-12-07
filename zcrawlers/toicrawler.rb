require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'csv'
require 'pry'

url = "http://timesofindia.indiatimes.com/world"
page = Nokogiri::HTML(open(url))

headline = []
description = []
url = []
body = []

#headline
page.css("div a").each do |title|
	headline << title.text
end

#description
# page.css("p.p2_2.clear").each do |dd|
# 	description << dd.text
# end

#url
url = page.css('div a').map { |link| link['href'] }

#body
agent = Mechanize.new
mpage = agent.get('http://timesofindia.indiatimes.com/world')
body_links = mpage.links.find_all {|l| l.attributes.parent.name == 'h1' }

binding.pry


body_links.each do |l|
	next_page = l.click
	puts next_page.at("//div")
	body << next_page.at("//div")
end
binding.pry
#############################

#CONSOLE
(0..headline.length - 1).each do |index|
	puts "headline: #{headline[index]}"
	puts "description : #{description[index]}"
	puts "link : #{url[index]}\n"  
end

#DATABASE
(0..headline.length - 1).each do |index|
	article = India.create(headline: headline[index], summary: description[index], url: url[index], body: body[index])
end

#CSV
CSV.open("india.csv", "wb") do |row|
	row << ["headline", "description", "link", "body"]
	(0..headline.length - 1).each do |index|
		row << [headline[index], description[index], url[index], body[index]]
	end
end
