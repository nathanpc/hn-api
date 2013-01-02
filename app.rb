#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'mongrel'

require File.join(File.dirname(__FILE__), 'api/section.rb')
require File.join(File.dirname(__FILE__), 'api/comment.rb')
require File.join(File.dirname(__FILE__), 'api/vote.rb')
require File.join(File.dirname(__FILE__), 'api/submit.rb')


app = Mongrel::HttpServer.new("0.0.0.0", "8080")

app.register("/section", Section.new)
app.register("/comment", Comment.new)
app.register("/vote", Vote.new)
app.register("/submit", Submit.new)

app.run.join