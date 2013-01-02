require 'rubygems'
require 'mongrel'
require 'ruby-hackernews'
require 'json'
#require 'gabba'

#require 'analytics.rb'
require File.join(File.dirname(__FILE__), '..', 'helpers/build_json.rb')


class Comment < Mongrel::HttpHandler
	include RubyHackernews

	def process(request, response)
		args = request.params["REQUEST_PATH"].split("/")
		args.shift()

		response.start(200) do |head, out|
			head["Content-Type"] = "application/json"

			if args[1] == "list"
				# Requested comments from a entry
				json = { :comments => [] }

				#Gabba::Gabba.new(tracking_id, tracking_site).page_view("Comment List", "comment/list")
				BuildJSON.comment(args, json)

				out.write(json.to_json)
			elsif args[1] == "submit"
				# Post a comment
				#Gabba::Gabba.new(tracking_id, tracking_site).page_view("Submit Comment", "comment/submit")
				if request.params["REQUEST_METHOD"] == "POST"			
					basic_auth = Base64.decode64(request.params["HTTP_AUTHORIZATION"].split(" ")[1]).split(":")
					username = basic_auth[0]
					password = basic_auth[1]
					user = User.new(username)
				
					if user.login(password)
						# Logged
						if args[1] == "entry"
							Entry.find(Integer(args[2])).write_comment(request.body.read)
						elsif args[1] == "reply"
							Comment.find(Integer(args[2])).reply(request.body.read)
						end
				
						out.write({
							:success => "Commented."
						}.to_json)
				
						user.logout()
					else
						# Wrong credentials
						out.write({
							:error => "Wrong username || password"
						}.to_json)
					end
				else
					# Not POST
					out.write({
						:error => "Must be a POST."
					}.to_json)
				end
				puts 
			else
				json = { :error => "Undefined argument for /#{args[0]}. Usage: /#{args[0]}/:entry_id" }
			end
		end
	end
end