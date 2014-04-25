#!/usr/bin/env ruby
# encoding: utf-8

require 'subexec'

# file paths
@data_path = 'data/hr.gov.ge/'
@response_file = 'response.html'
@json_file = 'data.json'
@db_config_path = 'database.yml'

# start id for hr.jobs.ge
@hr_job_ge_start_id = 903

def create_directory(file_path)
	if !file_path.nil? && file_path != "."
		FileUtils.mkpath(file_path)
	end
end

# json template that is populated with hr.gov.ge data
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




# create sql for insert statements
def create_job_sql_insert(mysql, json, source, locale)
  fields = []
  values = []
  sql = nil
  
  fields << 'source'
  values << source

  fields << 'locale'
  values << locale
  
  fields << 'created_at'
  values << Time.now

  if !json["general"]["vacancy_id"].nil?
    fields << 'job_id'
    values << json["general"]["vacancy_id"]
  end
  if !json["general"]["position"].nil?
    fields << 'position'
    values << json["general"]["position"]
  end
  if !json["general"]["provided_by"].nil?
    fields << 'provided_by'
    values << json["general"]["provided_by"]
  end
  if !json["general"]["category"].nil?
    fields << 'category'
    values << json["general"]["category"]
  end
  if !json["general"]["deadline"].nil?
    fields << 'deadline'
    values << json["general"]["deadline"]
  end
  if !json["general"]["salary"].nil?
    fields << 'salary'
    values << json["general"]["salary"]
    
    # split salary into its start and end components
    cleaned = nil
    if locale == 'eng'
      cleaned = json["general"]["salary"].gsub(' GEL', '').gsub('From ', '').gsub('To ', '').gsub(' - ', '-').gsub('- ', '-').strip
    elsif locale == 'geo'
      cleaned = json["general"]["salary"].gsub(' ლარი', '').gsub(' ლარიდან', '').gsub(' ლარამდე', '').gsub('დან', '').gsub(' - ', '-').gsub('- ', '-').strip
    end
    
    # if numbers are present, continue
    if !cleaned.nil? && !(cleaned =~ /[0-9]/).nil?
      fields << 'salary_start'
      fields << 'salary_end'
      if cleaned.index('-').nil?
        # no dash, so just save it as it is
        values << cleaned
        values << cleaned
      elsif cleaned[0] == '-'
        # text is like '-234' so get rid of '-' and save number
        values << cleaned.gsub('-', '')
        values << cleaned.gsub('-', '')
      else
        # have both start and end salaries
        # start
        values << cleaned.split('-')[0]
        # end
        values << cleaned.split('-')[1]
      end
    end
  end
  if !json["general"]["num_positions"].nil?
    fields << 'num_positions'
    values << json["general"]["num_positions"]
  end
  if !json["general"]["location"].nil?
    fields << 'location'
    values << json["general"]["location"]
  end
  if !json["general"]["job_type"].nil?
    fields << 'job_type'
    values << json["general"]["job_type"]
  end
  if !json["general"]["probation_period"].nil?
    fields << 'probation_period'
    values << json["general"]["probation_period"]
  end
  if !json["contact"]["address"].nil?
    fields << 'contact_address'
    values << json["contact"]["address"]
  end
  if !json["contact"]["phone"].nil?
    fields << 'contact_phone'
    values << json["contact"]["phone"]
  end
  if !json["contact"]["contact_person"].nil?
    fields << 'contact_person'
    values << json["contact"]["contact_person"]
  end
  if !json["job_description"].nil?
    fields << 'job_description'
    values << json["job_description"]
  end
  if !json["additional_requirements"].nil?
    fields << 'additional_requirements'
    values << json["additional_requirements"]
  end
  if !json["additional_info"].nil?
    fields << 'additional_info'
    values << json["additional_info"]
  end
  if !json["qualifications"]["degree"].nil?
    fields << 'qualifications_degree'
    values << json["qualifications"]["degree"]
  end
  if !json["qualifications"]["work_experience"].nil?
    fields << 'qualifications_work_experience'
    values << json["qualifications"]["work_experience"]
  end
  if !json["qualifications"]["profession"].nil?
    fields << 'qualifications_profession'
    values << json["qualifications"]["profession"]
  end
  if !json["qualifications"]["age"].nil?
    fields << 'qualifications_age'
    values << json["qualifications"]["age"]
  end
  if !json["qualifications"]["knowledge_legal_acts"].nil?
    fields << 'qualifications_knowledge_legal_acts'
    values << json["qualifications"]["knowledge_legal_acts"]
  end

  if !fields.empty? && !values.empty?
    sql = "insert into jobs("
    sql << fields.join(', ')
    sql << ") values("
    sql << values.map{|x| "\"#{mysql.escape(x.to_s)}\""}.join(', ')
    sql << ")"
  end
  
  return sql
end

def create_language_sql_insert(mysql,json, jobs_id)
  fields = ['jobs_id', 'created_at', 'language', 'writing', 'reading']
  values = []
  sql = nil

  if !json['languages'].empty?
    json['languages'].each do |lang|
      x = []

      x << jobs_id
      
      x << Time.now
      
      if !lang['language'].nil?
        x << lang['language']
      else
        x << ''
      end
      if !lang['writing'].nil?
        x << lang['writing']
      else
        x << ''
      end
      if !lang['reading'].nil?
        x << lang['reading']
      else
        x << ''
      end
      values << x.map{|z| "\"#{mysql.escape(z.to_s)}\""}.join(', ')
    end
  end

  if !values.empty?
    sql = "insert into knowledge_languages("
    sql << fields.join(', ')
    sql << ") values "
    sql << values.map{|z| "( #{z} )" }.join(', ')
  end

  return sql  
end


def create_computer_sql_insert(mysql,json, jobs_id)
  fields = ['jobs_id', 'created_at', 'program', 'knowledge']
  values = []
  sql = nil

  if !json['computers'].empty?
    json['computers'].each do |lang|
      x = []

      x << jobs_id
      
      x << Time.now
      
      if !lang['program'].nil?
        x << lang['program']
      else
        x << ''
      end
      if !lang['knowledge'].nil?
        x << lang['knowledge']
      else
        x << ''
      end

      values << x.map{|z| "\"#{mysql.escape(z.to_s)}\""}.join(', ')
    end
  end

  if !values.empty?
    sql = "insert into knowledge_computers("
    sql << fields.join(', ')
    sql << ") values "
    sql << values.map{|z| "( #{z} )" }.join(', ')
  end

  return sql  
end

# dump the database
def dump_database(db_config, log)
  log.info "------------------------------"
  log.info "dumping database"
  log.info "------------------------------"
  Subexec.run "mysqldump -u#{db_config["username"]} -p#{db_config["password"]} #{db_config["database"]} | gzip > \"#{db_config["database"]}.sql.gz\" "
end



# update github with any changes
def update_github
  @log.info "------------------------------"
  @log.info "updating git"
  @log.info "------------------------------"
  x = Subexec.run "git add -A"
  x = Subexec.run "git commit -am 'Automated new jobs collected on #{Time.now.strftime('%F')}'"
  x = Subexec.run "git push origin master"
end
