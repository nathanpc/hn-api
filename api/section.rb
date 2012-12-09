require 'rubygems'
require 'mongrel'
require 'ruby-hackernews'
require 'json'
require 'yaml'

require 'helpers/build_json.rb'


class Section < Mongrel::HttpHandler
	include RubyHackernews

	def process(request, response)
		args = request.params["REQUEST_PATH"].split("/")
		args.shift()
		#puts request.to_yaml
		
		response.start(200) do |head, out|
			head["Content-Type"] = "application/json"
			json = { :entries => [] }
			
			if args[1] == "home"
				entries = Entry.all
				
				unless args[2].nil?
					begin
						entries = Entry.all(Integer(args[2]))
					rescue
						if args[2] == "page"
							# TODO: Implement pagging instead of just returning a lot of stuff from all the pages.
						else
							# TODO: Implement error.
						end
					end
				end
				
				entries.each do |entry|
					json[:entries].push(BuildJSON.entry(entry))
				end
			else
				json = { :error => "Undefined argument for /#{args[0]}, valid ones are /#{args[0]}/home, /#{args[0]}/new, /#{args[0]}/ask" }
			end

			out.write(json.to_json)
		end
	end
end