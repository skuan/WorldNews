class RussiaController < ApplicationController

	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	require 'csv'
	require 'pry'

	def home

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