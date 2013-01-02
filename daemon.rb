require 'rubygems'
require 'daemons'

pwd  = File.dirname(File.expand_path(__FILE__))
file = File.join(pwd, "app.rb")

Daemons.run_proc("hn-api", :log_output => true) do
	exec "ruby #{file}"
end