#!/usr/bin/env ruby

require 'json'
require 'csv'

report_date = Time.now.strftime('%Y%m%d%H%M%S')

# get all files for each announcement on hr.gov.ge
# src: jumpstart georgia scraper
# https://github.com/JumpStartGeorgia/Job-Announcement-Scraper

# clone repository locally to run script

# script takes one arg: the path to the repository's root directory

repo_root_dir = ARGV[0] # no trailing slash

files = Dir.glob("#{repo_root_dir}/data/hr.gov.ge/*/*/eng/data.json")

jobs = Array.new

files.each do |f|
  text = File.open(f).read
  data = JSON.parse(text)
  date = data['general']['deadline']
  jobs << date
end

# count each job

job_count_by_day = Hash.new(0) # set default of 0
job_count_by_month = Hash.new(0) # set default of 0

jobs.each do |job|
	date_array = job.split('/')
	date_month = "#{date_array[0]}/#{date_array[1]}"
  job_count_by_day[job] += 1
  job_count_by_month[date_month] += 1
end

# sort results
job_count_by_day_sorted = job_count_by_day.sort_by { |k,v| v }.to_h
job_count_by_month_sorted = job_count_by_month.sort_by { |k,v| v }.to_h

# write report to file which are named by the date/time

CSV.open("#{report_date}_by_day.csv", "w") do |d|
  job_count_by_day_sorted.each do |k,v|
    d << [k, v] 
  end
end

CSV.open("#{report_date}_by_month.csv", "w") do |m|
  job_count_by_month_sorted.each do |k,v|
    m << [k,v]
  end
end