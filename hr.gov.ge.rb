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

####################################
def create_directory(file_path)
	if !file_path.nil? && file_path != "."
		FileUtils.mkpath(file_path)
	end
end

start = Time.now

# log file to record messages
# delete existing log file
#File.delete('hr.gov.ge.log') if File.exists?('hr.gov.ge.log')
@log = Logger.new('hr.gov.ge.log')

@log.info "**********************************************"
@log.info "**********************************************"

# data path
@data_path = 'data/hr.gov.ge/'
@response_file = 'response.html'
@json_file = 'data.json'


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
def get_start_id
  id = 903 # default value
  
  folders = Dir.glob(@data_path + "*")
  if Dir.exists?(@data_path) && !folders.empty?
    start = folders.map{|x| x.split('/')[2].to_i}.sort.last
    id = start + 1 if !start.nil?
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

# start / end ids
start_id = get_start_id
end_id = get_end_id

# if start id is >= end id, stop
if start_id >= end_id
  @log.info "------------------------------"
  @log.info "The start id is >= end id, so there is nothing to do."
  @log.info "------------------------------"
  exit
end

# total number of records to process 
# is end - start * 2,
# where 2 represents the 
total_to_process = (end_id - start_id + 1) * @locales.length
total_left_to_process = (end_id - start_id + 1) * @locales.length
@log.info "There are #{total_to_process} records to process"

####################################################

def json_template
  json = {}
  json[:general] = {}
  json[:general][:position] = nil
  json[:general][:provided_by] = nil
  json[:general][:category] = nil
  json[:general][:deadline] = nil
  json[:general][:salary] = nil
  json[:general][:num_positions] = nil
  json[:general][:location] = nil
  json[:general][:job_type] = nil
  json[:general][:probation_period] = nil
  json[:general][:vacancy_id] = nil

  json[:contact] = {}
  json[:contact][:address] = nil
  json[:contact][:phone] = nil
  json[:contact][:contact_person] = nil
  
  json[:job_description] = nil
  json[:additional_requirements] = nil
  json[:additional_info] = nil

  json[:qualifications] = {}
  json[:qualifications][:degree] = nil
  json[:qualifications][:work_experience] = nil
  json[:qualifications][:profession] = nil
  json[:qualifications][:age] = nil
  json[:qualifications][:degree] = nil
  json[:qualifications][:knowledge_legal_acts] = nil

  # computers
  json[:computers] = []

  # languages
  json[:languages] = []

  json
end

# not all fields are required
# and there is no unique id for each field
# so have to use the title text to find index to get value
@keys = {}
@keys[:eng] = {}
@keys[:eng][:general] = {}
@keys[:eng][:general][:position] = 'position:'
@keys[:eng][:general][:provided_by] = 'provided by:'
@keys[:eng][:general][:category] = 'category:'
@keys[:eng][:general][:deadline] = 'application deadline:'
@keys[:eng][:general][:salary] = 'salary:'
@keys[:eng][:general][:num_positions] = 'number of positions:'
@keys[:eng][:general][:location] = 'location:'
@keys[:eng][:general][:job_type] = 'job type:'
@keys[:eng][:general][:probation_period] = 'probation period:'
@keys[:eng][:general][:vacancy_id] = 'vacancy n:'
@keys[:eng][:qualifications] = {}
@keys[:eng][:qualifications][:degree] = 'degree'
@keys[:eng][:qualifications][:work_experience] = 'work experience'
@keys[:eng][:qualifications][:profession] = 'profession'
@keys[:eng][:qualifications][:age] = 'age'
@keys[:eng][:qualifications][:knowledge_legal_acts] = 'knowledge of legal acts'
@keys[:eng][:contact] = {}
@keys[:eng][:contact][:address] = 'address'
@keys[:eng][:contact][:phone] = 'phone number'
@keys[:eng][:contact][:contact_person] = 'contact person'

@keys[:geo] = {}
@keys[:geo][:general] = {}
@keys[:geo][:general][:position] = 'თანამდებობის დასახელება:'
@keys[:geo][:general][:provided_by] = 'დამსაქმებელი:'
@keys[:geo][:general][:category] = 'კატეგორია:'
@keys[:geo][:general][:deadline] = 'განცხადების წარდგენის ბოლო ვადა:'
@keys[:geo][:general][:salary] = 'თანამდებობრივი სარგო:'
@keys[:geo][:general][:num_positions] = 'ადგილების რაოდენობა:'
@keys[:geo][:general][:location] = 'სამსახურის ადგილმდებარეობა:'
@keys[:geo][:general][:job_type] = 'სამუშაოს ტიპი:'
@keys[:geo][:general][:probation_period] = 'გამოსაცდელი ვადა:'
@keys[:geo][:general][:vacancy_id] = 'ვაკანსიის n:'
@keys[:geo][:qualifications] = {}
@keys[:geo][:qualifications][:degree] = 'მინიმალური განათლება'
@keys[:geo][:qualifications][:work_experience] = 'სამუშაო გამოცდილება'
@keys[:geo][:qualifications][:profession] = 'პროფესია'
@keys[:geo][:qualifications][:age] = 'ასაკი'
@keys[:geo][:qualifications][:knowledge_legal_acts] = 'სამართლებრივი აქტების ცოდნა'
@keys[:geo][:contact] = {}
@keys[:geo][:contact][:address] = 'საკონტაქტო მისამართი'
@keys[:geo][:contact][:phone] = 'საკონტაქტო ტელეფონები'
@keys[:geo][:contact][:contact_person] = 'საკონტაქტო პირი'




# process the response
def process_response(response)
  # pull out the locale and id from the url
  params = response.request.url.split('/')
  if params.length == 8 

    locale = params[3]
    id = params[params.length-1]
    
#    @log.info "processing response for id #{id} and locale #{locale}"

    # get the response body
    doc = Nokogiri::HTML(response.body)
    
  
    # save the response body
    file_path = @data_path + id + "/" + locale + "/" + @response_file
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
    file_path = @data_path + id + "/" + locale + "/" + @json_file
		create_directory(File.dirname(file_path))
    File.open(file_path, 'w'){|f| f.write(json.to_json)}
  else
    @log.error "response url is not in expected format: #{response.request.url}; expected url.split('/') to have length of 8 but has length of #{params.length}"
  end
end

##########################

#initiate hydra
hydra = Typhoeus::Hydra.new(max_concurrency: 20)
request = nil

#build hydra queue
(start_id..end_id).map do |i|
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
        @log.info "It took #{Time.now - start} seconds to process #{total_to_process} items"
        @log.info "------------------------------"
      end
    end


    hydra.queue(request)
  end
end

hydra.run

