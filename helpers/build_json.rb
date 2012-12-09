require 'rubygems'
require 'json'

class BuildJSON
	def self.entry(entry)
		return {
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
		}
	end
end