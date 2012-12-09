#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'mongrel'

require 'api/section.rb'
require 'api/comment.rb'


app = Mongrel::HttpServer.new("0.0.0.0", "8080")

app.register("/section", Section.new)
app.register("/comment", Comment.new)

app.run.join