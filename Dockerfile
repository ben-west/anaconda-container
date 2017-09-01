FROM debian:8.5
# Forked from https://github.com/ContinuumIO/docker-images/tree/master/anaconda3
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
    build-essential \
    gcc \
    zsh \
    git-all \
    curl \
    grep \
    sed \
    dpkg && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    curl https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh > ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

RUN /opt/conda/bin/pip install  datacleaner mlxtend && \
    /opt/conda/bin/conda install jupyter -y && \
    /opt/conda/bin/conda install -c districtdatalabs yellowbrick && \
    git clone https://github.com/hyperopt/hyperopt-sklearn.git /tmp/hpsklearn && \
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

RUN  conda install -y nb_conda_kernels &&\
    conda create -y -n py27 python=2.7 ipykernel &&\
    conda create -y -n py36 python=3.6 ipykernel

# Source files should live in a persistent volume rather than in volatile storage
RUN mkdir -p /data
VOLUME /data

ENTRYPOINT [ "/usr/bin/tini", "--" ]

CMD [ "/bin/bash", "-c", "jupyter notebook --notebook-dir=/Data --ip='*' --port=8888 --no-browser --allow-root" ]
