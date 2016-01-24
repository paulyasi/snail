require 'mechanize'
require_relative 'pages'

page = Pages.new()
page.url = "http://www.coffeebuzz.com"

def parse_page(page)
	agent = Mechanize.new
	mech = agent.get(page.url)

	wordhash = {}
	words = mech.search('body').text.split(' ')
	words.each do|word|
		if word.length > 4
			if wordhash.has_key?(word)
				wordhash[word] = wordhash[word] + 1
			else
				wordhash[word] = 1
			end
		end
	end

	links = []
	mech.links.each do |link|
		links.push(link.href)
	end

	page.title = mech.title
	page.description = 'page description'
	page.links = links
	page.topics = wordhash.sort_by(&:last).reverse[0..5]

	return page

end

page = parse_page(page)
puts page.links
puts page.title


