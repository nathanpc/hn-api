require 'rubygems'
require 'mongrel'
require 'ruby-hackernews'
require 'json'
require 'base64'
#require 'gabba'

#require 'analytics.rb'


class Vote < Mongrel::HttpHandler
	include RubyHackernews

	def process(request, response)
		args = request.params["REQUEST_PATH"].split("/")
		args.shift()

		if request.params["REQUEST_METHOD"] == "POST"
			unless request.params["HTTP_AUTHORIZATION"].nil?
				response.start(200) do |head, out|
					head["Content-Type"] = "application/json"

					basic_auth = Base64.decode64(request.params["HTTP_AUTHORIZATION"].split(" ")[1]).split(":")
					username = basic_auth[0]
					password = basic_auth[1]
					user = User.new(username)

					if user.login(password)
						# Logged
						if args[1] == "entry"
							# Upvote a entry
							#Gabba::Gabba.new(tracking_id, tracking_site).page_view("Upvote Entry", "upvote/entry")
							Entry.find(Integer(args[2])).upvote
							out.write({
								:success => "The entry has been upvoted."
							}.to_json)
						elsif args[1] == "comment"
							# Upvote a comment
							comment_index = args[3].split(";")

							if comment_index[1].nil?
								#Gabba::Gabba.new(tracking_id, tracking_site).page_view("Upvote Comment", "upvote/comment")
								Entry.find(Integer(args[2])).comments[comment_index[0]].upvote
							else
								#Gabba::Gabba.new(tracking_id, tracking_site).page_view("Upvote Comment Reply", "upvote/comment")
								Entry.find(Integer(args[2])).comments[comment_index[0]][comment_index[1]].upvote
							end

							out.write({
								:success => "The comment has been upvoted."
							}.to_json)
						else
							# Hmm...
							out.write({
								:error => "Looks like your URL is malformed."
							}.to_json)
						end

						user.logout()
					else
						# Wrong credentials
						out.write({
							:error => "Wrong username || password"
						}.to_json)
					end
				end
			else
				response.start(403) do |head, out|
					out.write("Where's the Basic Auth?!")
				end
			end
		else
			response.start(403) do |head, out|
				out.write("You should've use POST.")
			end
		end
	end
end