require 'rubygems'
require 'mongrel'
require 'ruby-hackernews'
require 'json'
#require 'gabba'

#require 'analytics.rb'
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
				# Requested the Front Page
				#Gabba::Gabba.new(tracking_id, tracking_site).page_view("Front Page List", "section/all")
				BuildJSON.entry("all", args, json)
			elsif args[1] == "new"
				# Requested the New Page
				#Gabba::Gabba.new(tracking_id, tracking_site).page_view("New List", "section/new")
				BuildJSON.entry("newest", args, json)
			elsif args[1] == "ask"
				# Requested the Ask Page
				#Gabba::Gabba.new(tracking_id, tracking_site).page_view("Ask HN List", "section/ask")
				BuildJSON.entry("questions", args, json)
			else
				json = { :error => "Undefined argument for /#{args[0]}, valid ones are /#{args[0]}/home, /#{args[0]}/new, /#{args[0]}/ask" }
			end

			out.write(json.to_json)
		end
	end
end