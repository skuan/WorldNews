class PagesController < ApplicationController

	require 'rubygems'
	# require 'nokogiri'
	# require 'mechanize'
	require 'open-uri'
	require 'csv'
	# require 'pry'

	def home

# CHINA PORTION

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
		puts next_page.at("//div[@id='p_content']")
		body << next_page.at("//div[@id='p_content']")
	end
	##############################
	#CONSOLE
	(0..headline.length - 1).each do |index|
		puts "headline: #{headline[index]}"
		puts "description : #{description[index]}"
		puts "link : #{url[index]}\n" 
		puts "body : #{body[index]}\n\n" 
	end

	#DATABASE
	(0..headline.length - 1).each do |index|
		article = Pd.create(headline: headline[index], summary: description[index], url: url[index], body: body[index].text)
	end

	#CSV
	CSV.open("pd.csv", "wb") do |row|
		row << ["headline", "description", "link", "body"]
		(0..headline.length - 1).each do |index|
			row << [headline[index], description[index], url[index], body[index].text]
		end
	end

	@peoples_daily = Pd.all





# RUSSIA PORTION 

	url = "http://www.rt.com/news"
	page = Nokogiri::HTML(open(url))

	headline = []
	summary = []
	url = []
	body = []

	#headline
	page.css("dt").each do |dt|
		headline << dt.text
	end

	#summary
	page.css("dd").each do |dd|
		summary << dd.text
	end
	summary.shift

	#url issue with first url is just a, not a.header
	url = page.css('dt a').map { |link| link['href'] }

	#body
	agent = Mechanize.new 
	rtpage = agent.get('http://www.rt.com/news')
	rt_links = rtpage.links.find_all {|l| l.attributes.parent.name == 'dl'}

	rt_links.each do |l|
		next_page = l.click
		puts next_page.at("//p")
		body << next_page.at("//p")
	end


###########################
	#console
	(0..summary.length - 1).each do |index|
		puts "headline: #{headline[index]}"
		puts "description : #{summary[index]}"
		puts "link : #{url[index]}\n"
		puts "body : #{body[index]}\n"  
	end
	
	#database
	(0..headline.length - 1).each do |index|
		article = Russia.create(headline: headline[index], summary: description[index], url: url[index], body: body[index])
	end

	CSV.open("rt.csv", "wb") do |row|
		row << ["headline", "description", "link", "body"]
			(0..headline.length - 1).each do |index|
				row << [headline[index], description[index], url[index], body[index]]
		end
	end

	@russian_times = Russia.all


	end

end