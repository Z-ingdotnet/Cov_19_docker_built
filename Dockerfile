   # Install R version 3.x
FROM rocker/r-ver:3.6.3

## Install Ubuntu packages
RUN apt-get update && apt-get install -y \
#    gdebi-core \
#    pandoc \
#    pandoc-citeproc \
#    libcurl4-gnutls-dev \
#    libcairo2-dev \
#    libxt-dev \
#    libssl-dev \
#    libxml2-dev \
#    cmake \
    ## Pro-specific
#    libpam0g-dev \
#    r-base \
#    r-base-dev \
    sudo \
    nano \
    git \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    xtail \
    wget

## Download and install ShinyServer (latest version)
#RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
#    VERSION=$(cat version.txt)  && \
#    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
#    gdebi -n ss-latest.deb && \
#    rm -f version.txt ss-latest.deb

RUN wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    . /etc/environment && \
    R -e "install.packages(c('readr','reshape2','lubridate','rgdal','shiny','shinydashboard','maptools','ggplot2','ggthemes','rgeos','dplyr','repmis','scatterpie','RColorBrewer','shiny.i18n'), dependencies=TRUE,repos='http://cran.rstudio.com/')" && \
	cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/    
	#cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    #chown shiny:shiny /var/lib/shiny-server && \
	#chown shiny:shiny /srv/shiny-server/
# Make the ShinyApp available at port 80
EXPOSE 80


COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf

COPY /app /srv/shiny-server/ 

COPY shiny-server.sh /usr/bin/shiny-server.sh 

CMD ["/usr/bin/shiny-server.sh"]
