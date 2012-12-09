#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'mongrel'

require 'api/section.rb'


app = Mongrel::HttpServer.new("0.0.0.0", "8080")

app.register("/section", Section.new)
#app.register("/files", Mongrel::DirHandler.new("."))

app.run.join