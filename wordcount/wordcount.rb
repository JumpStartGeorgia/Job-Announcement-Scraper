#!/usr/bin/env ruby

require 'json'


source = ARGV[0] # jobsge hrgovge
language = ARGV[1] # eng geo

date = Time.now.strftime('%Y%m%d%H%M')
data_dir = 'data'
output_corpus = date + '_' + source + '_' + '.txt'
output_frequency = date + '_' + source + '_' + '.csv'

# data parse and write corpus text to file

File.open(data_dir + '/' + output_corpus, 'w') do |corpus|
  if source == 'jobsge'
    Dir['#{language}**/*.json'])
  elsif source == 'hrgovge'
  
  end
end

# basic clean of corpus text



# parse corpus text to create unique list

# write list to csv 
