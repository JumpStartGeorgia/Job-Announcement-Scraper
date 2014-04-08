# encoding: utf-8
#!/usr/bin/env ruby

##########################
## SCRAPER FOR hr.gov.ge
##########################

require 'typhoeus'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'logger'
require 'fileutils'

require_relative 'utilities'
require_relative 'database'

@start = Time.now

# log file to record messages
# delete existing log file
#File.delete('hr.gov.ge.log') if File.exists?('hr.gov.ge.log')
@log = Logger.new('hr.gov.ge.log')

@log.info "**********************************************"
@log.info "**********************************************"


####################################

# which languages to process
@locales = [:ka, :en]

# urls to scrape
@base_url = "https://www.hr.gov.ge/"
@urls = {}
@urls[:en] = {}
@urls[:en][:locale] = "eng"
@urls[:en][:url] = "#{@base_url}eng/vacancy/jobs/georgia/"
@urls[:ka] = {}
@urls[:ka][:locale] = "geo"
@urls[:ka][:url] = "#{@base_url}geo/%E1%83%95%E1%83%90%E1%83%99%E1%83%90%E1%83%9C%E1%83%A1%E1%83%98%E1%83%90/jobs/georgia/"

####################################

# get the id to start
# - if there are no records on file then use 903, the first id
# - else use the last record on file + 1
#   - to get last record, get name of last folder in the last folder
def get_start_id
  id = @hr_job_ge_start_id # default value
  
  folders = Dir.glob(@data_path + "*")
  if Dir.exists?(@data_path) && !folders.empty?
    length = @data_path.split('/').length
    # get the last folder
    last_folder = folders.map{|x| x.split('/')[length].to_i}.sort.last
    # now in that folder, get the last folder
    new_path = @data_path + last_folder.to_s + "/"
    length = new_path.split('/').length
    sub_folders = Dir.glob(new_path + "*")
    if !sub_folders.empty?
      last_folder = sub_folders.map{|x| x.split('/')[length].to_i}.sort.last
      id = last_folder + 1 if !last_folder.nil?
    end
  end
  @log.info "start id = #{id}"
  id
end

# get the most current id
# - it is possible that the ids are not in sequential order, 
#   so get all ids on page and then pull the largest one
# - you can override the end id by supplying it as an argument
def get_end_id
  if ARGV.length == 1
    id = ARGV.first.to_i
  else
    page = Nokogiri::HTML(open(@base_url + @urls[:en][:locale]))
    links = page.css('td#vac_ldate')
    ids = links.map{|x| x['onclick'].split("'")[1].split("/").last.to_i}.sort
    id = ids.last
  end
  @log.info "end id = #{id}"
  id
end

####################################################





# process the response
def process_response(response)
  # pull out the locale and id from the url
  params = response.request.url.split('/')
  if params.length == 8 

    locale = params[3]
    id = params[params.length-1]
    # get the name of the folder for this id
    # - the name is the id minus it's last 2 digits
    id_folder = id[0..id.length-3]
    folder_path = @data_path + id_folder + "/" + id + "/" + locale + "/"
    
#    @log.info "processing response for id #{id} and locale #{locale}"

    # get the response body
    doc = Nokogiri::HTML(response.body)
    
  
    # save the response body
    file_path = folder_path + @response_file
		create_directory(File.dirname(file_path))
    File.open(file_path, 'w'){|f| f.write(doc)}
    
    if doc.css('#content-main').length == 0
      @log.error "the response does not have any content to process"
      return
    end
    
    # create the json
    json = json_template
    
    # general info
    general_title = doc.css('#content-main #general_info li.title')
    general_lists = doc.css('#content-main #general_info li.info')
    if general_title.length > 0 && general_lists.length > 0
      json[:general].keys.each do |key|
        index = general_title.to_a.index{|x| x.text.strip.downcase == @keys[locale.to_sym][:general][key]}
        if index
          json[:general][key] = general_lists[index].text.strip    
        end      
      end      
    end

    # job description
    descriptions = doc.css('#content-main #job_description p')
    if descriptions.length > 0
      json[:job_description] = descriptions[0].text.strip
      json[:additional_requirements] = descriptions[1].text.strip if descriptions.length > 1
      json[:additional_info] = descriptions[2].text.strip if descriptions.length > 2
    end

    # contact info
    contacts_title = doc.css('#content-main #contact_info li.title')
    contacts = doc.css('#content-main #contact_info li.info')
    if contacts_title.length > 0 && contacts.length > 0
      json[:contact].keys.each do |key|
        index = contacts_title.to_a.index{|x| x.text.strip.downcase == @keys[locale.to_sym][:contact][key]}
        if index
          json[:contact][key] = contacts[index].text.strip    
        end      
      end      
    end
    
    # qualifications
    qualifications_title = doc.css('#content-main #qualifications li.title')
    qualifications = doc.css('#content-main #qualifications li.info')
    if qualifications_title.length > 0 && qualifications.length > 0
      json[:qualifications].keys.each do |key|
        index = qualifications_title.to_a.index{|x| x.text.strip.downcase == @keys[locale.to_sym][:qualifications][key]}
        if index
          json[:qualifications][key] = qualifications[index].text.strip    
        end      
      end      
    end    

    # computers
    computers = doc.css('#content-main #computer table tr')
    if computers.length > 0
      computers.each_with_index do |computer, index|
        if index > 0
          h = {}
          tds = computer.css('td')
          if tds.length > 0
            h[:program] = tds[0].text.strip
            h[:knowledge] = tds[1].text.strip
            json[:computers] << h            
          end
        end
      end
    end

    # languages
    languages = doc.css('#content-main #languages table tr')
    if languages.length > 0
      languages.each_with_index do |language, index|
        if index > 0
          h = {}
          tds = language.css('td')
          if tds.length > 0
            h[:language] = tds[0].text.strip
            h[:writing] = tds[1].text.strip
            h[:reading] = tds[2].text.strip
            json[:languages] << h            
          end
        end
      end
    end

    # save the json
    file_path = folder_path + @json_file
		create_directory(File.dirname(file_path))
    File.open(file_path, 'w'){|f| f.write(json.to_json)}
  else
    @log.error "response url is not in expected format: #{response.request.url}; expected url.split('/') to have length of 8 but has length of #{params.length}"
  end
end

##########################

def make_requests(ids)

  # total number of records to process 
  # is the ids length * locales.length
  total_to_process = ids.length * @locales.length
  total_left_to_process = ids.length * @locales.length
  @log.info "There are #{total_to_process} records to process"


  #initiate hydra
  hydra = Typhoeus::Hydra.new(max_concurrency: 20)
  request = nil

  #build hydra queue
  ids.each do |i|
    @locales.each do |locale|
      url = @urls[locale][:url] + i.to_s
      request = Typhoeus::Request.new("#{url}", followlocation: true)

      request.on_complete do |response|
        if response.success?
          # put success callback here
          @log.info("#{response.request.url} - success")
          
          # process the response        
          process_response(response)
        elsif response.timed_out?
          # aw hell no
          @log.warn("#{response.request.url} - got a time out")
        elsif response.code == 0
          # Could not get an http response, something's wrong.
          @log.error("#{response.request.url} - no response: #{response.return_message}")
        else
          # Received a non-successful http response.
          @log.error("#{response.request.url} - HTTP request failed: #{response.code.to_s}")
        end
        
        # decrease counter of items to process
        total_left_to_process -= 1
        if total_left_to_process == 0
          @log.info "------------------------------"
          @log.info "It took #{Time.now - @start} seconds to process #{total_to_process} items"
          @log.info "------------------------------"
          
          # now update the database
          update_database
          
          # now push to git
          update_github
        end
      end


      hydra.queue(request)
    end
  end

  hydra.run

end

####################################
# process any new items
####################################
# get the start / end ids
start_id = get_start_id
end_id = get_end_id

# if start id is >= end id, stop
if start_id >= end_id
  @log.info "------------------------------"
  @log.info "The start id is >= end id, so there is nothing to do."
  @log.info "------------------------------"

  # now update the database
  update_database
  
  # now push to git
  update_github
  
else
  # get the information
  make_requests((start_id..end_id).to_a)
end

=begin
####################################
# look for items on file, but with no json file
# if found, try reprocessing them
####################################

# get all item folders
puts 'getting all folders'
folders = Dir.glob(@data_path + "*")
all_ids = nil
if Dir.exists?(@data_path) && !folders.empty?
puts 'pulling out folder ids'
  all_ids = folders.map{|x| x.split('/')[2].to_i}.sort
end

# get all items that have json file
puts 'getting all folders with json'
folders = Dir.glob(File.join(@data_path,"**","*.json"))
good_ids = nil
if Dir.exists?(@data_path) && !folders.empty?
  puts "found #{folders.length} folders"
  (0..5).each do |i|
    puts folders[i]
  end
end

=end



