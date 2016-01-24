require 'mechanize'
require_relative 'pages'

starting_url = "http://www.coffeebuzz.com"

def parse_page(url)
	puts "---------------------- Parsing URL: #{url}"
	page = Pages.new()
	agent = Mechanize.new
	begin
		mech = agent.get(url)

		wordhash = {}
		begin
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
		rescue
			wordhash = {}
		end


		links = []
		begin
			mech.links.each do |link|
				begin
					nexturl = mech.uri.merge link.href
				rescue
					nexturl = link.href
				end
				puts nexturl
				links.push(nexturl)
			end
		rescue
			links = []
		end

		begin
			page.title = mech.title
		rescue
			page.title = "No Title"
		end

		page.description = 'page description'
		page.links = links
		page.topics = wordhash.sort_by(&:last).reverse[0..5]

		return page
	rescue
		puts "invalid url #{url}"
		# not a valid url, do nothing
	end

end

page = parse_page(starting_url)
puts page.links
page.links.each do |url|
    new_page = parse_page(url)
end


