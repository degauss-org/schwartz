#!/usr/local/bin/Rscript

library(dplyr)
library(schwartzGeohashPM)

doc <- '
Usage:
  schwartz.R <filename> <aws_key> <aws_secret_key>
'

opt <- docopt::docopt(doc)
## for interactive testing
## opt <- docopt::docopt(doc, args = 'test/my_address_file_geocoded.csv')

message('\nreading input file...')
raw_data <- readr::read_csv(opt$filename)

if (! 'sitecode' %in% names(raw_data)) stop('no column called sitecode found in the input file', call. = FALSE)
if (! 'start_date' %in% names(raw_data)) stop('no column called start_date found in the input file', call. = FALSE)
if (! 'end_date' %in% names(raw_data)) stop('no column called end_date found in the input file', call. = FALSE)

if(class(raw_data$sitecode) != "double") {
  raw_data$sitecode <- as.double(raw_data$sitecode)
}

if(class(raw_data$start_date) != "Date") {
  raw_data$start_date <- as.Date(raw_data$start_date)
}

if(class(raw_data$end_date) != "Date") {
  raw_data$end_date <- as.Date(raw_data$end_date)
}

Sys.setenv("AWS_ACCESS_KEY_ID" = opt$aws_key,
           "AWS_SECRET_ACCESS_KEY" = opt$aws_secret_key,
           "AWS_DEFAULT_REGION" = "us-east-2")

## function for creating a geomarker based on a single sf point
out <- schwartzGeohashPM::add_schwartz_pollutants(raw_data, download_dir = fs::path_wd())

out_file_name <- paste0(tools::file_path_sans_ext(opt$filename), '_schwartz.csv')
readr::write_csv(out, out_file_name)
message('\nFINISHED! output written to ', out_file_name)
