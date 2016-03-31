#!/usr/bin/env ruby
# a web crawler experiment
# determine topic of content by crawling title of internal pages of website

require 'mechanize'
require_relative 'pages'

starting_url = "http://www.coffeebuzz.com"
$wordhash = {}

def get_title(url)
	agent = Mechanize.new
	mech = agent.get(url)
	mech.title

  begin
    words = mech.search('body').text.split(' ')
    puts "BODY"
    puts words
    words.each do|word|
      if word.length > 3
        puts "get_title words"
        puts word
        if $wordhash.has_key?(word)
          $wordhash[word] = $wordhash[word] + 1
          puts "w+1"
        else
          $wordhash[word] = 1
        end
      end
    end
  rescue
    # oops
  end

end

def parse_page(url)
	puts "---------------------- Parsing URL: #{url}"
	page = Pages.new()
	agent = Mechanize.new
	begin
		mech = agent.get(url)

		#wordhash = {}
		begin
			words = mech.search('body').text.split(' ')
			words.each do|word|
				if word.length > 3
          		puts "word:"
          		puts word
					if $wordhash.has_key?(word)
						$wordhash[word] = $wordhash[word] + 1
						puts "w+1"
					else
						$wordhash[word] = 1
					end
				end
			end
		rescue
			# oops
		end

    titlehash = {}

		links = []
		begin
			mech.links.each do |link|
				begin
					nexturl = mech.uri.merge link.href
					titlewords = get_title(nexturl)
          words = titlewords.split(' ')
          words.each do|word|
            if word.length > 3
              puts word
              if titlehash.has_key?(word)
                titlehash[word] = titlehash[word] + 1
              else
                titlehash[word] = 1
              end
            end
          end
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
		page.topics = titlehash.sort_by(&:last).reverse[0...10]

		return page

	rescue
		puts "invalid url #{url}"
		# not a valid url, do nothing
	end

end

page = parse_page(starting_url)
puts page.title
puts page.topics
puts "wordhash:"
puts $wordhash

# puts page.links
# page.links.each do |url|
#     new_page = parse_page(url)
# end


