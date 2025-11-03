# pull base image
FROM alpine:3.22

ARG ANSIBLE_CORE_VERSION=2.18.4
ARG ANSIBLE_VERSION=11.4.0
ARG ANSIBLE_LINT=25.2.1
ARG AWS_CLI_VERSION=2.31.27

ENV ANSIBLE_CORE_VERSION=${ANSIBLE_CORE_VERSION}
ENV ANSIBLE_VERSION=${ANSIBLE_VERSION}
ENV ANSIBLE_LINT=${ANSIBLE_LINT}
ENV AWS_CLI_VERSION=${AWS_CLI_VERSION}


RUN apk --no-cache add \
        sudo \
        curl \
        python3\
        py3-pip \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        git && \
    apk --no-cache add --virtual build-dependencies \
        python3-dev \
        libffi-dev \
        musl-dev \
        gcc \
        cargo \
        build-base && \
    find /usr/lib/python* -name "EXTERNALLY-MANAGED" -exec rm {} \; && \
    pip3 install --upgrade pip wheel && \
    pip3 install --upgrade cryptography cffi pywinrm && \
    pip3 install ansible-core==${ANSIBLE_CORE_VERSION} ansible==${ANSIBLE_VERSION} ansible-lint==${ANSIBLE_LINT} && \
    pip3 install mitogen jmespath && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/pip && \
    rm -rf /root/.cargo && \
    rm -rf /var/lib/apt/lists/*

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

# Install boto3, botocore
RUN pip install --no-cache-dir boto3 botocore

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]
