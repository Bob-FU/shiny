FROM rocker/r-ver:3.6.1
RUN apt-get update -qq &&\
    apt-get install -y gnupg wget locales locales-all &&\
    apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' &&\
    echo "deb http://cran.rstudio.com/bin/linux/debian stretch-cran35/" | tee -a /etc/apt/sources.list  &&\
    apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    xtail \
    wget libxml2-dev r-base  libssl-dev


# Download and install shiny server
RUN wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    . /etc/environment && \
    R -e "install.packages(c('rsconnect', 'shiny', 'rmarkdown', 'purrr', 'jsonlite', 'gsheet', 'shiny.i18n', 'zoo', 'countup', 'tabulizer', 'tidyverse', 'lubridate', 'gtools', 'googlePolylines', 'jpmesh', 'sf', 'units'), repos='$MRAN')" && \
    R -e "install.packages('devtools')" &&\
    R -e "remotes::install_github('swsoyee/echarts4r')" &&\
    R -e "remotes::install_github('JohnCoene/echarts4r.maps')" &&\
    R -e "install.packages('shinydashboard')" &&\
    R -e "install.packages('data.table')" &&\
    R -e "install.packages('DT')" &&\
    R -e "install.packages('ggplot2')" &&\
    R -e "install.packages('shinycssloaders')" &&\
    R -e "install.packages('shinydashboardPlus')" &&\
    R -e "install.packages('shinyWidgets')" &&\
    R -e "install.packages('leaflet')" &&\
    R -e "install.packages('rjson')" &&\
    R -e "install.packages('htmltools')" &&\
    R -e "install.packages('leaflet.minicharts')" &&\
    R -e "install.packages('sparkline')" &&\
    R -e "install.packages('shinyBS')" &&\
    R -e "install.packages('forcats')" &&\
    R -e "install.packages('jpndistrict')" &&\
    R -e "remotes::install_github('JohnCoene/countup')"  &&\
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    chown shiny:shiny /var/lib/shiny-server

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]

