require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'csv'
require 'pry'

url = "http://en.people.cn/"
page = Nokogiri::HTML(open(url))

headline = []
description = []
url = []
body = []

#headline
page.css("h2.p2_1.clear a").each do |title|
	headline << title.text
end
#description
page.css("p.p2_2.clear").each do |dd|
	description << dd.text
end
#url
url = page.css('h2.p2_1.clear a').map { |link| link['href'] }

#body
agent = Mechanize.new
mpage = agent.get('http://en.people.cn/')
body_links = mpage.links.find_all {|l| l.attributes.parent.name == 'h2'}



body_links.each do |l|
	next_page = l.click
	puts next_page.at("//div[@id='p_content']").text
end
binding.pry



	# while result_page do 
	# 	puts result_page.at("//div[@id='p_content']")

	# 	# body << result_page.at("//div[@id='p_content']").text
	# end


#CONSOLE
(0..headline.length - 1).each do |index|
	puts "headline: #{headline[index]}"
	puts "description : #{description[index]}"
	puts "link : #{url[index]}\n"  
end

#DATABASE
(0..headline.length - 1).each do |index|
	article = Pd.create(headline: headline[index], summary: description[index], url: url[index], body: body[index])
end

#CSV
CSV.open("pd.csv", "wb") do |row|
	row << ["headline", "description", "link", "body"]
	(0..headline.length - 1).each do |index|
		row << [headline[index], description[index], url[index], body[index]]
	end
end