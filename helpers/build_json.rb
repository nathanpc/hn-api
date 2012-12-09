require 'rubygems'
require 'ruby-hackernews'
require 'json'

class BuildJSON
	def self.entry(section, args, json)
		include RubyHackernews
		entries = Entry.send(section)
		
		unless args[2].nil?
			begin
				# Requested more than just one page
				entries = Entry.send(section, (Integer(args[2])))
			rescue
				if args[2] == "page"
					# Requested a specific page
					entries = Entry.send(section, (Integer(args[3])))
		
					undesired_posts = (Integer(args[3]) - 1) * 30
					entries = entries.drop(undesired_posts)
				end
			end
		end
		
		entries.each do |entry|
			json[:entries].push({
				:index => entry.number,
				:title => entry.link.title,
				:link => {
					:site => entry.link.site,
					:url => entry.link.href
				},
				:user => entry.user.name,
				:votes => entry.voting.score,
				:comments => entry.comments_count,
				:time => entry.time  # TODO: Create a function to beautify the time.
			})
		end
	end
end