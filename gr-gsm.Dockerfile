FROM ubuntu:xenial
# Shenanigainer
MAINTAINER Miguel Luís <mkxpto+docker@gmail.com>
# Set environment variables
ENV APT_DEPS build-essential apt-utils python-pip python-apt
ENV PIP_DEPS pip PyBOMBS
ENV DEBIAN_FRONTEND noninteractive
# Set working directory
WORKDIR /data
# Define volumes
VOLUME /data
# Install dependencies
RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y $APT_DEPS 
# Install actual program
RUN pip install --upgrade $PIP_DEPS && \
    pybombs auto-config && \
    # @BUGGY!6.10.17 # pip install --upgrade git+https://github.com/gnuradio/pybombs.git && \
    pybombs recipes add-defaults && \
    pybombs prefix init ./gnur -a gnur && \
    printf "[list]\nformat=columns\n" >> /etc/pip.conf && \
    pybombs -p ./gnur install gr-gsm
# Define
ENTRYPOINT  ["/bin/bash"]
