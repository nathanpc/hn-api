require 'rubygems'
require 'mongrel'

class Ping < Mongrel::HttpHandler
	def process(request, response)
		response.start(200) do |head, out|
			head["Content-Type"] = "text/plain"
			out.write("PONG")
		end
	end
end