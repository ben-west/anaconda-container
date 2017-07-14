FROM debian:8.5

MAINTAINER Kamil Kwiek <kamil.kwiek@continuum.io>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && \
    apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    unzip\
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    apt-utils \
    git \
    mercurial \
    subversion \
    build-essential \
    gcc \
    zsh \
    git-all \
    curl \
    grep \
    sed \
    dpkg && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda2-4.4.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

RUN /opt/conda/bin/pip install  datacleaner mlxtend && \
    /opt/conda/bin/conda install jupyter -y && \
    /opt/conda/bin/conda install -c districtdatalabs yellowbrick


RUN git clone https://github.com/hyperopt/hyperopt-sklearn.git /tmp/hpsklearn && \
    cd /tmp/hpsklearn && \
    /opt/conda/bin/python setup.py install && \
    rm -rf /tmp/hpsklearn

RUN mkdir -p /tmp && \
    wget -v "http://featureselection.asu.edu/download_file.php?filename=scikit-feature-1.0.0.zip&dir=files/" -O /tmp/scikit-feature-1.0.0.zip && \
    ls -la /tmp && \
    cd /tmp/ && \
    unzip scikit-feature-1.0.0.zip && \
    cd /tmp/scikit-feature-1.0.0  && \
    /opt/conda/bin/python setup.py install && \
    cd / && \
    rm -rf /tmp/scikit-feature-1.0.0

ENV PATH /opt/conda/bin:$PATH

RUN mkdir -p /data
VOLUME /data

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
