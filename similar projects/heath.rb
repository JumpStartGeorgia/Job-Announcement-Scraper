#!/usr/bin/env ruby
# encoding: utf-8

BASE_URL = "https://www.hr.gov.ge/eng/vacancy/jobs/georgia/"

require 'ostruct'
require 'typhoeus'
require 'nokogiri'
require 'time'
require 'json'

require_relative 'util'

if ARGV.length != 2
  $stderr.puts "Invalid arguments.\nUsage: gerip.rb <start index> <concurrency>"
  exit
end

concurrency = ARGV[1].to_i

context = OpenStruct.new(
  :index => ARGV.first.to_i, 
  :last_index => fetch_article_bounds(),
  :hydra => Typhoeus::Hydra.new, 
  #:results => File.open('results.json', 'w'), 
  :results => $stdout)

if not context.last_index
  $stderr.puts "Unable to find article bounds"
  exit
else
  $stderr.puts "Starting at index #{context.index}; Last index = #{context.last_index}"
end

$stderr.sync = true
concurrency.times do |i|
  $stderr.print "." 
  context.hydra.queue(build_request(context))
end

$stderr.puts "\nRunning with concurrency #{concurrency}..."
context.hydra.run

