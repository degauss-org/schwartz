#!/usr/local/bin/Rscript

dht::greeting(geomarker_name = 'schwartz',
              version = '0.5.5',
              description = 'adds daily PM2.5, NO2, and O3 concentrations from the Schwartz Model')

library(dht)
qlibrary(dplyr)
qlibrary(schwartzGeohashPM)

doc <- '
Usage:
  schwartz.R <filename>
'

opt <- docopt::docopt(doc)
## for interactive testing
## opt <- docopt::docopt(doc, args = 'test/my_address_file_geocoded_schwartz_site_index.csv')

# read in data
message('\nreading input file...')
raw_data <- readr::read_csv(opt$filename)

# check for sitecode formatting
message('\nchecking sitecodes...')
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

## add pollutant data
message('joining Schwartz estimates to data...')
out <- schwartzGeohashPM::add_schwartz_pollutants(raw_data, verbose = TRUE)

dht::write_geomarker_file(d = out,
                          filename = opt$filename,
                          geomarker_name = 'schwartz',
                          version = '0.5.5' )

