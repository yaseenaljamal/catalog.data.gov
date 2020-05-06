FROM ubuntu:bionic

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN apt-get -q -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade \
    && apt-get -q -y install \
        python-dev \
        python-pip \
        python-virtualenv \
        python-wheel \
        libpq-dev \
        libxml2-dev \
        libxslt-dev \
        libgeos-dev \
        libssl-dev \
        libffi-dev \
        postgresql-client \
        build-essential \
        git-core \
        vim \
        wget \
        curl \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists/*

ENV CKAN_HOME /usr/lib/ckan
ENV CKAN_VENV $CKAN_HOME/venv

RUN addgroup --gid $GROUP_ID ckan && \
    adduser --uid $USER_ID --home $CKAN_HOME --ingroup ckan --disabled-password --gecos '' ckan

RUN chown -R ckan:ckan $CKAN_HOME
USER ckan

RUN mkdir -p $CKAN_VENV && \
    virtualenv $CKAN_VENV

VOLUME /src
WORKDIR /src

