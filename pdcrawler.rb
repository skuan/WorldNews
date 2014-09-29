require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pry'

url = "http://english.peopledaily.com.cn/90777/index.html"
page = Nokogiri::HTML(open(url))

headline = []
description = []
url = []


page.css("h3 a").each do |title|
	headline << title.text
end

page.css("div.on2.clear").each do |dd|
	description << dd.text
end

url = page.css('h3 a').map { |link| link['href'] }

(0..headline.length - 1).each do |index|
	puts "headline: #{headline[index]}"
	puts "description : #{description[index]}"
	puts "link : #{url[index]}\n"  
end

#database
(0..headline.length - 1).each do |index|
	article = Pd.create(headline: headline[index], summary: description[index], url: url[index])
end

CSV.open("pd.csv", "wb") do |row|
	row << ["headline", "description", "link"]
	(0..headline.length - 1).each do |index|
		row << [headline[index], description[index], url[index]]
	end
end