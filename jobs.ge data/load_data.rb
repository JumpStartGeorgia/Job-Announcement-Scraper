#!/usr/bin/env ruby
# encoding: utf-8

require 'subexec'
require 'shellwords'

@db_config = {}
@db_config['username'] = 'root'
@db_config['password'] = 'root'
@db_config['database'] = 'jobs.ge'
@db_config['database_processed'] = 'jobs.ge-processed'

@structure_path = 'structure.sql'
@other_data_path = 'data_except_jobs.sql'
@jobs_data_path = 'jobs_data'

def load_file(file_path)
  x = Subexec.run "mysql -u'#{@db_config["username"]}' -p'#{@db_config["password"]}' #{@db_config["database"]} < #{file_path} "
  puts x.output
end

if File.exists?(@structure_path)
  ##############
  # load the original jobs.ge data
  ##############
  # drop tables first
  puts "dropping existing tables for #{@db_config['database']}"
  x = Subexec.run "mysqldump -u'#{@db_config["username"]}' -p'#{@db_config["password"]}' --no-data #{@db_config["database"]} grep ^DROP > drop.sql "
  x = Subexec.run "mysql -u'#{@db_config["username"]}' -p'#{@db_config["password"]}' #{@db_config["database"]} < drop.sql "
  x = Subexec.run "rm drop.sql "
  
  # load the structure
  puts 'loading structure'
  load_file(@structure_path.shellescape)

  # load the other data if it exists
  puts 'loading other data'
  load_file(@other_data_path.shellescape) if File.exists?(@other_data_path)
  
  # for each file in @jobs_data_path, load it
  Dir.glob(File.join(@jobs_data_path,"*.sql")).each do |file|
    puts "loading file #{file}"
    load_file(file.shellescape)
  end

  ##############
  # now clean the data and create a dump
  ##############
  # drop exisitng tables
  puts "dropping existing tables for #{@db_config['database_processed']}"
  x = Subexec.run "mysqldump -u'#{@db_config["username"]}' -p'#{@db_config["password"]}' --no-data #{@db_config["database_processed"]} grep ^DROP > drop.sql "
  x = Subexec.run "mysql -u'#{@db_config["username"]}' -p'#{@db_config["password"]}' #{@db_config["database_processed"]} < drop.sql "
  x = Subexec.run "rm drop.sql "

  # create new tables with the correct charset
  puts "creating tables with the correct charset"
  cmd = "mysqldump -u'#{@db_config["username"]}' -p'#{@db_config["password"]}' #{@db_config["database"]} --no-data --skip-set-charset --default-character-set=latin1 " 
  cmd << "| sed 's/CHARSET=latin1/CHARSET=utf8/g' "
  cmd << "| sed 's/CHARACTER SET latin1//g' "
  cmd << "| sed 's/CHARACTER SET utf8//g' "
  cmd << "| mysql -u'#{@db_config["username"]}' -p'#{@db_config["password"]}' #{@db_config["database_processed"]} --default-character-set=utf8 "
  x = Subexec.run cmd
  
  # now load the data into the clean database
  puts "loading data into clean database"
  cmd = "mysqldump -u'#{@db_config["username"]}' -p'#{@db_config["password"]}' #{@db_config["database"]} --no-create-db --no-create-info --skip-set-charset --default-character-set=latin1  " 
  cmd << "| mysql -u'#{@db_config["username"]}' -p'#{@db_config["password"]}' #{@db_config["database_processed"]} --default-character-set=utf8 "
  x = Subexec.run cmd

  # dump the data
  puts "dumping clean database"
  Subexec.run "mysqldump -u'#{@db_config["username"]}' -p'#{@db_config["password"]}' #{@db_config["database_processed"]} | gzip > \"#{@db_config["database"]}.sql.gz\" "

end


