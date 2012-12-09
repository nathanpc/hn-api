#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'mongrel'

require 'api/section.rb'
require 'api/comment.rb'
require 'api/vote.rb'



app = Mongrel::HttpServer.new("0.0.0.0", "8080")

app.register("/section", Section.new)
app.register("/comment", Comment.new)
app.register("/vote", Vote.new)

app.run.join