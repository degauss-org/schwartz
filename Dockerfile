FROM rocker/r-ver:3.6.1

# install required version of renv
RUN R --quiet -e "install.packages('remotes', repos = 'https://cran.rstudio.com')"
# make sure version matches what is used in the project: packageVersion("renv")
ENV RENV_VERSION 0.8.3-81
RUN R --quiet -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

WORKDIR /app

RUN apt-get update \
  && apt-get install -yqq --no-install-recommends \
  libudunits2-dev=2.2.20-1+b1 \
  libproj-dev=4.9.3-1 \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  && apt-get clean

COPY renv.lock .
RUN R --quiet -e "renv::restore()"
RUN R --quiet -e "reticulate::install_miniconda()"
RUN R --quiet -e "reticulate::py_install('boto3')"

COPY schwartz.R .

WORKDIR /tmp

ENTRYPOINT ["/app/schwartz.R"]
