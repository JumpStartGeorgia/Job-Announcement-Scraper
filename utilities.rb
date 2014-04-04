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



