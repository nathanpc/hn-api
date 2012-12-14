require 'rubygems'
require 'mongrel'
require 'ruby-hackernews'
require 'json'
#require 'gabba'


class Submit < Mongrel::HttpHandler
	include RubyHackernews

	def process(request, response)
		response.start(200) do |head, out|
			head["Content-Type"] = "application/json"
			json = { :success => "It worked" }

			req_json = JSON.parse(request.body.read)
			Entry.submit(req_json["title"], req_json["detail"])

			out.write(json.to_json)
		end
	end
end