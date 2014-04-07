#Scraper for job postings in Georgia. 

This scraper will copy the job postings from hr.gov.ge and do the following for each language:
* save the html of each web page
* pull out the data and create a json file
* load the json data to a database (optional)

## How to use it

###Gems
Make sure you have the following gems installed
* typhoeus
* nokogiri
* open-uri
* json
* logger
* fileutils

If you are going to use the db portion:
* mysql2
* yaml

###Running It
Simply run: 
```ruby
ruby hr.gov.ge.rb
```

When the script starts it looks to see what was copied last and uses that as the starting point of the new session.  The ending point is determined by going to the hr.gov.ge page and getting the latest job id.

###Database
If you create a database.yml file with the connection string information to a database, the system will load the json data into the database. If the tables do not exist, they will automatically be created.  Look in the database.rb file for more information.  The database.yml file will not be saved to the git repo so that passwords are not made public.

