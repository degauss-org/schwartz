# schwartz <a href='https://degauss-org.github.io/DeGAUSS/'><img src='DeGAUSS_hex.png' align="right" height="138.5" /></a>

> add PM2.5, NO2, and O3 concentrations from Schwartz Model to data

[![Docker Build Status](https://img.shields.io/docker/automated/degauss/schwartz)](https://hub.docker.com/repository/docker/degauss/schwartz/tags)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/degauss-org/schwartz)](https://github.com/degauss-org/schwartz/releases)

## DeGAUSS example call

If `my_address_file_geocoded_schwartz_site_index_dates.csv` (output from the [`schwartz_grid_lookup`](https://degauss.org/schwartz_grid_lookup/) container) is a file in the current working directory with columns named `sitecode`, `start_date` and `end_date`, and `aws_key` and `aws_secret_key` are provided AWS credentials, then

```sh
docker run --rm -v "$PWD":/tmp degauss/schwartz:0.1 my_address_file_geocoded_schwartz_site_index_dates.csv aws_key aws_secret_key
```

will produce `my_address_file_geocoded_schwartz_site_index_dates_schwartz.csv` with added columns named `PM25`, `NO2`, and `O3`.

## geomarker methods

Details on methods can be found at [https://github.com/geomarker-io/schwartz_exposure_assessment](https://github.com/geomarker-io/schwartz_exposure_assessment)

## geomarker data

- Schwartz pollutant data is stored as [qs](https://github.com/traversc/qs) files in a private S3 bucket, which can only be accessed with appropriate AWS credentials. 

- Files are named with 3-digit geohash (or a combination of 3-digit geohashes in areas where population is sparse) and year of pollutant data. For example,  [`s3://geomarker/schwartz/exp_estimates_1km/by_gh3_year/dng_2016_round1.qs`](https://geomarker.s3.us-east-2.amazonaws.com/geomarker/schwartz/exp_estimates_1km/by_gh3_year/dng_2016_round1.qs)

## DeGAUSS details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS homepage](https://degauss.org).

