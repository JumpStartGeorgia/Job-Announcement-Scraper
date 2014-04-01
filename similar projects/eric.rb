#!/usr/bin/env ruby

require 'typhoeus'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'logger'

log = Logger.new('log_eric.txt')

urls = {}
urls[:en] = "https://www.hr.gov.ge/eng/vacancy/jobs/georgia/"
urls[:ka] = "https://www.hr.gov.ge/geo/%E1%83%95%E1%83%90%E1%83%99%E1%83%90%E1%83%9C%E1%83%A1%E1%83%98%E1%83%90/jobs/georgia/"

def get_latest_id
  page = Nokogiri::HTML(open('https://www.hr.gov.ge/eng/'))
  id = page.css('td#vac_ldate').first['onclick'].split("'")[1].split("/").last
  id
end

def logger(type, status, date=Time.now)
  file = "logs/"
  File.open(file, "wa") do |f| 
    f << "#{type}"
    f.save
  end
end

# get end id
start_id = 903 
end_id = 905 #get_latest_id


#initiate hydra
hydra = Typhoeus::Hydra.new(max_concurrency: 20)

request = ''

#build hydra queue
(start_id.to_i..end_id.to_i).map do |i|
  puts "Getting: #{urls[:en].to_s + i.to_s}"
  request = Typhoeus::Request.new("#{urls[:en].to_s + i.to_s}", followlocation: true)

  request.on_complete do |response|
    if response.success?
      # put success callback here
      puts "#{response.request.url} - success"
      log.info("#{response.request.url} - success")
    elsif response.timed_out?
      # aw hell no
      puts "#{response.request.url} - got a time out"
      log.warn("#{response.request.url} - got a time out")
    elsif response.code == 0
      # Could not get an http response, something's wrong.
      puts "#{response.request.url} - no response: #{response.return_message}"
      log.error("#{response.request.url} - no response: #{response.return_message}")
    else
      # Received a non-successful http response.
      puts "#{response.request.url} - HTTP request failed: #{response.code.to_s}"
      log.error("#{response.request.url} - HTTP request failed: #{response.code.to_s}")
    end
  end


  hydra.queue(request)
end

hydra.run

