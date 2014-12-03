class PagesController < ApplicationController

	require 'rubygems'
	require 'nokogiri'
	require 'mechanize'
	require 'open-uri'
	require 'csv'
	require 'pry'

	def home

# CHINA PORTION

	url = "http://english.peopledaily.com.cn/90777/index.html"
	page = Nokogiri::HTML(open(url))

	headline = []
	description = []
	url = []
	body = []

	#headline
	page.css("h3 a").each do |title|
		headline << title.text
	end
	#summary
	page.css("div.on2.clear").each do |dd|
		description << dd.text
	end
	#url
	url = page.css('h3 a').map { |link| link['href'] }

	#body
	mechanize = Mechanize.new
	front_page = mechanize.get('http://english.peopledaily.com.cn/90777/index.html')
	url.each do |body_link|
		result_page = Mechanize::Page::Link.new(body_link, mechanize,front_page).click

		while result_page do
			puts result_page.at("//*[@id='p_content']")
			body << result_page.at("//*[@id='p_content']")
		end
	end


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

	@peoples_daily = Pd.all





# RUSSIA PORTION 

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
	url = page.css('dt a').map { |link| link['href'] }

	(0..summary.length - 1).each do |index|
		puts "headline: #{headline[index]}"
		puts "description : #{summary[index]}"
		puts "link : #{url[index]}\n"  
	end
	
	#database
	(0..headline.length - 1).each do |index|
		article = Russia.create(headline: headline[index], summary: description[index], url: url[index])
	end

	CSV.open("rt.csv", "wb") do |row|
		row << ["headline", "description", "link"]
			(0..headline.length - 1).each do |index|
				row << [headline[index], description[index], url[index]]
		end
	end

	@russian_times = Russia.all


	end

end