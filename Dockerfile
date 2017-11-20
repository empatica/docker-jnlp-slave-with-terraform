FROM empatica/jnlp-slave-with-docker:3.14-1
MAINTAINER Giannicola Olivadoti <go@empatica.com>

USER root

RUN apt-get update && \
    apt-get -y install python python-pip groff && \
    rm -rf /var/lib/apt/lists/*

ENV TERRAFORM_HOME /opt/terraform
ENV TERRAFORM_VERSION 0.9.6

ARG TERRAFORM_DOWNLOAD_SHA256=7ec24a5d57da6ef7bdb5a3003791a4368489b32fa93be800655ccef0eceaf1ba

RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip && \
    echo "${TERRAFORM_DOWNLOAD_SHA256} terraform.zip" | sha256sum --check - && \
    mkdir -p "${TERRAFORM_HOME}/bin" && \
    unzip terraform.zip && \
    rm terraform.zip && \
    mv terraform "${TERRAFORM_HOME}/bin" && \
    ln -s "${TERRAFORM_HOME}/bin/terraform" /usr/bin/terraform

USER jenkins

RUN pip install --upgrade awscli s3cmd python-magic docker-compose && \
    mkdir -p /home/jenkins/.terraform && \
    mkdir -p /home/jenkins/.aws

# ENV PATH ${PATH}:${HOME}/.local/bin

VOLUME "/home/jenkins/.terraform"
VOLUME "/home/jenkins/.aws"

USER root

RUN ln -s "${HOME}/.local/bin/aws" /usr/bin/aws && \
    ln -s "${HOME}/.local/bin/docker-compose" /usr/bin/docker-compose
