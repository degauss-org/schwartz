#!/usr/local/bin/Rscript

library(dplyr)
library(schwartzGeohashPM)

doc <- '
Usage:
  schwartz.R <filename>
'

opt <- docopt::docopt(doc)
## for interactive testing
## opt <- docopt::docopt(doc, args = 'test/my_address_file_geocoded.csv')

# read in data
message('\nreading input file...')
raw_data <- readr::read_csv(opt$filename)

# ensure appropriate columns exist
if (! 'sitecode' %in% names(raw_data)) stop('no column called sitecode found in the input file', call. = FALSE)
if (! 'start_date' %in% names(raw_data)) stop('no column called start_date found in the input file', call. = FALSE)
if (! 'end_date' %in% names(raw_data)) stop('no column called end_date found in the input file', call. = FALSE)

# check for sitecode formatting
if(class(raw_data$sitecode) != "double") {
  raw_data$sitecode <- as.double(raw_data$sitecode)
}

check_sitecodes <- raw_data %>%
  mutate(sitecode_char = as.character(sitecode),
         sitecode_suff = stringr::str_sub(sitecode, -4)) %>%
  group_by(sitecode_suff) %>%
  tally() %>%
  mutate(pct = n/sum(n))

if (TRUE %in% check_sitecodes$pct >= 0.5) {
  warning("Over half of your sitecodes end in '0000'. Please verify sitecodes were not altered due to opening
          your file in Excel. For help ensuring sitecodes keep all digits, please see the DeGAUSS wiki.")
}

# check for date formatting
IsDateISO <- function(mydate, date.format = "%Y-%m-%d") {
  tryCatch(!is.na(as.Date(mydate, date.format)),
           error = function(err) {FALSE})
}

IsDateSlash <- function(mydate, date.format = "%m/%d/%y") {
  tryCatch(!is.na(as.Date(mydate, date.format)),
           error = function(err) {FALSE})
}

checkDates <- function(date) {
  dates_to_print <- date[1:3]

  if(class(date) != 'Date') {

    if(!FALSE %in% IsDateISO(date)) {
      date <- as.Date(date, format = "%Y-%m-%d")
      return(date)
    }  else if (!FALSE %in% IsDateSlash(date))
    {
      date <- as.Date(date, format = "%m/%d/%y")
      return(date)
    } else
    {
      message("\nYour dates are not properly formatted. Here are the first 3 dates in your data.\n")
      print(dates_to_print)
      stop("Dates must be formatted as YYYY-MM-DD or MM/DD/YY. For help, please see Excel formatting tips in the DeGAUSS wiki.",
           call. = FALSE)
    }
  }

  if(class(date) == 'Date') {
    return(date)
  }
}

raw_data$start_date <- checkDates(raw_data$start_date)
raw_data$end_date <- checkDates(raw_data$end_date)

if ('index_date' %in% colnames(raw_data)) {
  raw_data$index_date <- checkDates(raw_data$index_date)
}

## add pollutant data
out <- schwartzGeohashPM::add_schwartz_pollutants(raw_data)

out_file_name <- paste0(tools::file_path_sans_ext(opt$filename), '_schwartz.csv')
readr::write_csv(out, out_file_name)
message('\nFINISHED! output written to ', out_file_name)
