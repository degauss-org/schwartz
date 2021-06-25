FROM rocker/r-ver:4.0.4

# install required version of renv
RUN R --quiet -e "install.packages('remotes', repos = 'https://cran.rstudio.com')"
# make sure version matches what is used in the project: packageVersion("renv")
ENV RENV_VERSION 0.13.2
RUN R --quiet -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

WORKDIR /app

RUN apt-get update \
  && apt-get install -yqq --no-install-recommends \
  libudunits2-dev \
  libproj-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  zlib1g-dev \
  libgdal-dev \
  libgeos-dev \
  && apt-get clean

COPY renv.lock .
RUN R --quiet -e "renv::restore()"

COPY schwartz.R .

WORKDIR /tmp

ENTRYPOINT ["/app/schwartz.R"]
