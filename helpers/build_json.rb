require 'rubygems'
require 'ruby-hackernews'
require 'json'

class BuildJSON
	include RubyHackernews

	def self.entry(section, args, json)
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
				:id => Integer(entry.id),
				:title => entry.link.title,
				:link => {
					:site => entry.link.site,
					:url => entry.link.href,
					:text => entry.text
				},
				:user => entry.user.name,
				:votes => entry.voting.score,
				:comments => entry.comments_count,
				:time => entry.time  # TODO: Create a function to beautify the time.
			})
		end
	end
	
	def self.comment(args, json)
		# Getting the comments
		comments = Entry.find(Integer(args[2])).comments
		comments.each_with_index do |comment, index|
			votes = comment.voting.score
			if votes == nil
				votes = 0
			end

			json[:comments].push({
				:index => index,
				:user => comment.user.name,
				:votes => votes,
				:text => comment.text,
				:replies => []
			})
			
			comment.each_with_index do |reply, reply_index|
				# Populate replies
				reply_votes = reply.voting.score
				if reply_votes == nil
					reply_votes = 0
				end

				json[:comments][index][:replies].push({
					:index => reply_index,
					:user => reply.user.name,
					:votes => reply_votes,
					:text => reply.text
				})
			end
		end
	end
end