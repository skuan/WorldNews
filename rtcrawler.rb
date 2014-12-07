require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'csv'
require 'pry'

url = "http://www.rt.com/news"
page = Nokogiri::HTML(open(url))

headline = []
summary = []
url = []
b = []
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
rtagent = Mechanize.new 
rtpage = rtagent.get('http://www.rt.com/news')
rt_links = rtpage.links.find_all {|l| l.attributes.parent.name == 'dt'}


rt_links.each do |l|
	next_page = l.click
	puts next_page.at("div.cont-wp p")
# body > div.page > div.content.p-page.doc-page > div > div > div.cont-wp > div.cont-wp-mid.max_width > div.article_img > p
# body > div.page > div.content.p-page.doc-page > div > div > div.cont-wp > p:nth-child(4)
# body > div.page > div.content.p-page.doc-page > div > div > div.cont-wp > p:nth-child(5)
	b << next_page.at("div.cont-wp p").text
	b.each do |x|
		body << x
	end

end
	unique = body.uniq
	print unique, "\n"


###########################
#console
(0..summary.length - 1).each do |index|
	puts "headline: #{headline[index]}"
	puts "description : #{summary[index]}"
	puts "link : #{url[index]}\n"
	puts "body : #{body[index]}\n"  
end
binding.pry
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