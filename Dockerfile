FROM jupyter/scipy-notebook

MAINTAINER Jupyter Project <jupyter@googlegroups.com>

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    apt-utils \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libssl-dev \
    libpcre++-dev \
    liblzma-dev \
    libbz2-dev \
    libpq-dev \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER

# R packages including IRKernel which gets installed globally.
RUN conda config --system --add channels r && \
    conda install --quiet --yes \

# Conda: R libaries

    'rpy2=2.8*' \
    'r-base=3.3.2' \
    'r-irkernel=0.7*' \
    'r-plyr=1.8*' \
    'r-devtools=1.12*' \
    'r-tidyverse=1.0*' \
    'r-shiny=0.14*' \
    'r-rmarkdown=1.2*' \
    'r-forecast=7.3*' \
    'r-rsqlite=1.1*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.2*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-igraph' \
    'r-randomforest=4.6*'  \

# Conda: Python libaries

    'tensorflow' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

RUN R -e "install.packages(c(\
    'Amelia', \
    'shinydashboard', \
    'shinyjs', \
    'shinyWidgets', \
    'ggthemes', \
    'ggthemes', \
    'ggvis', \
    'data.table', \
    'networkD3', \
    'plotly', \
    'roxygen2', \
    'rgdal', \
    'RPostgreSQL', \
    'maptools', \
    'rgeos', \
    'spatstat', \
    'sp', \
    'spdep', \
    'network', \
    'visNetwork', \
    'ndtv', \
    'networkDynamic' \
    ), repos = 'http://cran.us.r-project.org')"

RUN  pip install \
     'psycopg2==2.7.3'  \
     'xgboost'  \
     'mlxtend'  \
     'xlsxwriter==0.9.6'  \
     'argh==0.26.1'  \
     'boto==2.39.0'  \
     'bottleneck==1.0.0'  \
     'brewer2mpl==1.4.1'  \
     'bz2file==0.98'  \
     'elasticsearch==1.9.0'  \
     'future==0.16.0'  \
     'gensim==0.12.4'  \
     'ggplot'  \
     'httpretty==0.8.10'  \
     'hyperopt'  \
     'hypothesis==2.0.0'  \
     'igraph'  \
     'nltk'  \
     'nose==1.3.7'  \
     'pathtools==0.1.2'  \
     'pprintpp==0.2.3'  \
     'py==1.4.31'  \
     'py-postgresql==1.1.0'  \
     'py2neo==2.0.8'  \
     'pydot2==1.0.33'  \
     'pydotplus==2.0.2'  \
     'pymongo==3.4.0'  \
     'pytest==3.0.1'  \
     'smartopen'  \
     'tika==1.15'  \
     'virtualenv'  \
     'watchdog==0.8.3' \
     'folium' \
     'keras'

RUN echo $NB_USER

USER root

RUN conda install --quiet --yes \
    libgdal && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR
