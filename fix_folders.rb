#!/usr/bin/env ruby

##############################################################
## - the initial design had each item at the root of hr.gov.ge
## - this created over 14,000 folders and caused the system to 
##   be very slow.  
## - this script re-organizes the folders into groups of 
##   100 items each
##############################################################

require 'fileutils'

start = Time.now

# data path
@data_path = 'data/hr.gov.ge/'
@data_path_finished = 'data/bad_hr.gov.ge/'
@temp_path = 'data/temp/'


def create_directory(file_path)
	if !file_path.nil? && file_path != "."
		FileUtils.mkpath(file_path)
	end
end

# create the temp directories
(9..145).each do |folder|
  create_directory(@temp_path + folder.to_s)
end

# move the folders into the correct temp directories
count = 0
Dir.foreach(@data_path) {|folder|
  if ['.', '..'].index(folder).nil?
    # get the parent name of the folder for this id
    # - the name is the id minus it's last 2 digits
    id_folder = folder[0..folder.length-3]
    
    old_path = @data_path + folder
    new_path = @temp_path + id_folder
    create_directory(new_path)
    FileUtils.cp_r old_path, new_path

    if count % 100 == 0
      puts "folders processed = #{count}"
    end
    count += 1
  end
}

# rename the current folder
FileUtils.mv @data_path, @data_path_finished

# rename the temp folder
FileUtils.mv @temp_path, @data_path

# delete the bad folder
FileUtils.rm_rf @data_path_finished


puts "this took #{Time.now - start} seconds!"
