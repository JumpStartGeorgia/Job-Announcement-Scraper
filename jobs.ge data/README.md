#How to process jobs.ge data. 
We have access to the jobs.ge database, however the database is so large and not properly encoded that some work is needed to get the data and make it readable.

The last complete database dump with cleaned data can be found in 'jobs.ge.sql.gz'. 

## Prep work
* create two databases with utf8 encoding named: jobs.ge and jobs.ge-processed
* uncompress the 'jobs_data.tar.bz2' folder - this contains all of the exisitng raw data in sql format from jobs.ge

## Getting the latest data
* The server the jobs.ge database is on is not able to dump the entire database at once, so you have to dump 1000 records at a time. I found that anymore than this and the server timesout.  I did this in phpmyadmin using a limit XXXX,1000 syntax. 
* After the query is run, export it as sql and add the file to the jobs_data folder.

## Processing the data
The encoding of this data is a mix-match of latin and utf8 with most of the Georgian text looking like this: áƒ¡áƒ®áƒ•áƒáƒ“áƒáƒ¡áƒ®áƒ•áƒ. And not just table encoding, column encoding too - utf8 tables with latin columns or latin tables with utf8 columns. An encoding nightmare. Luckily, I found a [simple solution](http://blog.whitesmith.co/latin1-to-utf8/) on how to fix the encoding.

The 'load_data.rb' file does the following:
* re-creates the tables and loads all of the sql files in the 'jobs_data' folder into the 'jobs.ge' database
* cleans and loads the data from 'jobs.ge' into 'jobs.ge-processed'
* dumps the clean data in 'jobs.ge-processed' and compresses it into a nice small file



