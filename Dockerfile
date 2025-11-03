# pull base image
FROM debian:bookworm-slim

ARG ANSIBLE_CORE_VERSION=2.18.4
ARG ANSIBLE_VERSION=11.4.0
ARG ANSIBLE_LINT=25.2.1
ARG AWS_CLI_VERSION=2.31.27

ENV ANSIBLE_CORE_VERSION=${ANSIBLE_CORE_VERSION}
ENV ANSIBLE_VERSION=${ANSIBLE_VERSION}
ENV ANSIBLE_LINT=${ANSIBLE_LINT}
ENV AWS_CLI_VERSION=${AWS_CLI_VERSION}
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
      sudo \
      curl \
      gnupg \
      wget \
      file \
      openssl \
      ca-certificates \
      sshpass \
      openssh-client \
      rsync \
      jq \
      git \
      unzip \
      build-essential \
      software-properties-common \
      libffi-dev \
      libssl-dev \
      python3 \
      python3-pip \
      python3-dev \
      python3-venv && \
    find /usr/lib/python* -name "EXTERNALLY-MANAGED" -exec rm {} \; && \
    pip3 install --upgrade pip wheel && \
    pip3 install --upgrade cryptography cffi pywinrm && \
    pip3 install ansible-core==${ANSIBLE_CORE_VERSION} ansible==${ANSIBLE_VERSION} ansible-lint==${ANSIBLE_LINT} && \
    pip3 install mitogen jmespath && \
    pip3 install --upgrade boto3 botocore && \
    apt-get remove -y build-essential python3-dev libffi-dev libssl-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache/pip

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

# Install awscliv2
# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
RUN curl -so "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" && \
    unzip -q awscliv2.zip && \
    aws/install && \
    rm -rf awscliv2.zip aws && \
    aws --version

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]
