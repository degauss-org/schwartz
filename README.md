# schwartz <a href='https://degauss-org.github.io/DeGAUSS/'><img src='DeGAUSS_hex.png' align="right" height="138.5" /></a>

> add daily PM2.5, NO2, and O3 concentrations from Schwartz Model to data

[![Docker Build Status](https://img.shields.io/docker/automated/degauss/schwartz)](https://hub.docker.com/repository/docker/degauss/schwartz/tags)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/degauss-org/schwartz)](https://github.com/degauss-org/schwartz/releases)

## DeGAUSS example call

If [`my_address_file_geocoded_schwartz_site_index.csv`](https://github.com/degauss-org/schwartz/blob/master/test/my_address_file_geocoded_schwartz_site_index.csv) (output from the [`schwartz_grid_lookup`](https://degauss.org/schwartz_grid_lookup/) container) is a file in the current working directory with columns named `sitecode`, `start_date`, `end_date`, and `index_date` (optional, see below), then

```sh
docker run --rm -v "$PWD":/tmp degauss/schwartz:0.5.3 my_address_file_geocoded_schwartz_site_index.csv
```

will produce [`my_address_file_geocoded_schwartz_site_index_schwartz.csv`](https://github.com/degauss-org/schwartz/blob/master/test/my_address_file_geocoded_schwartz_site_index_schwartz.csv) with added columns named `date`, `PM25`, `NO2`, `O3`, and `days_from_index_date` (if `index_date` was supplied in the input data). 

The output will be in "long" format, meaning there will be a row for every day between the `start_date` and `end_date`, defined by the new `date` column. 

## Optional `index_date`

The user may choose to include a column called `index_date` to be used to anonymize dates. For example, the index date may be the patient's date of birth. When the `index_date` column is present in the input data, the output will include all columns as usual, plus a column called `days_from_index_date` (defined as`date` - `index_date`). The user can then remove the `start_date`, `end_date`, and `index_date` columns from the output (as long as `index_date` is stored elsewhere) to anonymize the data in terms of date. 

## Dates and Sitecode formatting

- If `start_date` and `end_date` (and `index_date`) are not in ISO format (`YYYY-MM-DD`) or standard 'slash' format (`MM/DD/YY`), the container will return an error.

- If over half of the `sitecode`s end in all zeros, the container will return a warning, suggesting the user checks that sitecodes have not been unintentionally altered. 

See [Excel formatting for DeGAUSS](https://github.com/degauss-org/degauss-org.github.io/wiki/Excel-formatting-for-DeGAUSS) for more information.

## geomarker methods

Details on methods can be found at [https://github.com/geomarker-io/schwartz_exposure_assessment](https://github.com/geomarker-io/schwartz_exposure_assessment)

## geomarker data

- Schwartz pollutant data is stored as [qs](https://github.com/traversc/qs) files in a S3 bucket. 

- Files are named with 3-digit geohash (or a combination of 3-digit geohashes in areas where population is sparse) and year of pollutant data. For example,  [`s3://geomarker/schwartz/exp_estimates_1km/by_gh3_year/dng_2016_round1.qs`](https://geomarker.s3.us-east-2.amazonaws.com/geomarker/schwartz/exp_estimates_1km/by_gh3_year/dng_2016_round1.qs)

## DeGAUSS details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS homepage](https://degauss.org).

