# encoding: utf-8
#!/usr/bin/env ruby

####################################################
# to load the jobs to a database, please have the following:
# - database.yml file with the following keys and the appropriate values
# - the user must have the ability to create database and tables
# - this database.yml file is not saved into the git repository so
#   passwords are not shared with the world
# - yml keys:
#     database: 
#     username: 
#     password: 
#     encoding: utf8
#     host: localhost
#     port: 3306
#     reconnect: true

# - you will need to create the database
# - the tables will be created if they do not exist
####################################################

require 'mysql2'
require 'yaml'
require 'logger'

require_relative 'utilities'



# log file to record messages
# delete existing log file
#File.delete('hr.gov.ge.log') if File.exists?('hr.gov.ge.log')
log = Logger.new('database.log')

log.info "**********************************************"
log.info "**********************************************"

# make sure the file exists
if !File.exists?(@db_config_path)
  log.error "The #{@db_config_path} does not exist"
  exit
end

db_config = YAML.load_file(@db_config_path)

begin
  # create connection
  mysql = Mysql2::Client.new(:host => db_config["host"], :port => db_config["port"], :database => db_config["database"],
                              :username => db_config["username"], :password => db_config["password"],
                              :encoding => db_config["encoding"], :reconnect => db_config["reconnect"])

  ####################################################
  # if tables do not exist, create them
  ####################################################
  sql = "CREATE TABLE IF NOT EXISTS `jobs` (\
        `id` int(11) NOT NULL AUTO_INCREMENT,\
        `source` varchar(255) NOT NULL,\
        `job_id` varchar(255) NOT NULL,\
        `title` varchar(255) NOT NULL,\
        `provided_by` varchar(255) DEFAULT NULL,\
        `category` varchar(255) DEFAULT NULL,\
        `deadline` varchar(255) DEFAULT NULL,\
        `salary` varchar(255) DEFAULT NULL,\
        `num_positions` varchar(255) DEFAULT NULL,\
        `location` varchar(255) DEFAULT NULL,\
        `job_type` varchar(255) DEFAULT NULL,\
        `probation_period` varchar(255) DEFAULT NULL,\
        `contact_address` varchar(255) DEFAULT NULL,\
        `contact_phone` varchar(255) DEFAULT NULL,\
        `contact_person` varchar(255) DEFAULT NULL,\
        `job_description` text,\
        `additional_requirements` text,\
        `additional_info` text,\
        `qualifications_degree` varchar(255) DEFAULT NULL,\
        `qualifications_experience` varchar(255) DEFAULT NULL,\
        `qualifications_profession` varchar(255) DEFAULT NULL,\
        `qualifications_age` varchar(255) DEFAULT NULL,\
        `qualifications_knowledge_legal_acts` text,\
        KEY `Index 1` (`id`),\
        KEY `Index 2` (`job_id`)\
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8"
  mysql.query(sql)
  sql = "CREATE TABLE IF NOT EXISTS `knowledge_computers` (\
        `id` int(10) NOT NULL AUTO_INCREMENT,\
        `jobs_id` int(10) NOT NULL DEFAULT '0',\
        `program` varchar(255) DEFAULT NULL,\
        `knowledge` varchar(255) DEFAULT NULL,\
        KEY `Index 1` (`id`),\
        KEY `Index 2` (`jobs_id`)\
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8"
  mysql.query(sql)
  sql = "CREATE TABLE IF NOT EXISTS `knowledge_languages` (\
        `id` int(10) NOT NULL AUTO_INCREMENT,\
        `jobs_id` int(10) NOT NULL DEFAULT '0',\
        `language` varchar(255) DEFAULT NULL,\
        `writing` varchar(255) DEFAULT NULL,\
        `reading` varchar(255) DEFAULT NULL,\
        KEY `Index 1` (`id`),\
        KEY `Index 2` (`jobs_id`)\
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8"
  mysql.query(sql)
  

  ####################################################
  # get the last job id in the system
  # so know where to start
  ####################################################
  last_id = nil
  starT_id = nil
  mysql.query('select job_id from jobs order by job_id desc limit 1').each do |row|
    last_id = row['job_id']
    break
  end

  # if there are no records in the sytem, we are starting from scratch
  # else, search for the next folder after the last_id
  if last_id.nil?
    folders = Dir.glob(@data_path + "*")
    if Dir.exists?(@data_path) && !folders.empty?
      length = @data_path.split('/').length
      # get the first folder
      first_folder = folders.map{|x| x.split('/')[length].to_i}.sort.first
      # now in that folder, get the last folder
      new_path = @data_path + first_folder.to_s + "/"
      length = new_path.split('/').length
      sub_folders = Dir.glob(new_path + "*")
      if !sub_folders.empty?
        first_folder = sub_folders.map{|x| x.split('/')[length].to_i}.sort.first
        start_id = first_folder if !first_folder.nil?
      end
    end
  else
    start_id = last_id.to_i + 1    
  end

  if start_id.nil?
    log.warn "There are no data records on file to save to the database or the record to start loading data for could not be determined"
    exit
  end


  ####################################################
  # load the data
  ####################################################
  folder_id = start_id.to_s
  parent_folder = folder_id[0..folder_id.length-3]

  # get all of the parent folders
  parent_folders = Dir.glob(@data_path + "*")
  length = @data_path.split('/').length
  parent_folders.map!{|x| x.split('/')[length].to_i}.sort!.select!{|x| x >= parent_folder.to_i}

  # go through each folder and load all files that are in it
  parent_folders.each do |parent_folder|
    # only process if parent folder >= start id
    if parent_folder >= start_id
      # get json files in this folder

      # for each json file, load into table
    
    end
  end
  
rescue Mysql2::Error => e
  puts "Mysql error ##{e.errno}: #{e.error}"
ensure
  mysql.close if mysql
end
