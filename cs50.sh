#!/bin/bash

# Ubuntu-specific
apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        apt-file \
        apt-transport-https \
        bash-completion \
        bc \
        bsdtar \
        build-essential \
        clang \
        cmake \
        composer \
        curl \
        dnsutils \
        dos2unix \
        exiftool \
        gdb \
        gettext \
        git \
        git-lfs \
        imagemagick \
        info \
        man \
        mysql-client \
        nano \
        npm \
        openjdk-9-jdk \
        openjdk-9-jre \
        perl \
        php-cli \
        php-curl \
        php-gmp \
        php-intl \
        php-mcrypt \
        python \
        python-dev \
        python-pip \
        python3 \
        python3-dev \
        python3-pip \
        rpm \
        ruby `# 2.3 for now, hopefully 2.5 with Ubuntu 18.04` \
        s3cmd \
        software-properties-common \
        sqlite3 \
        telnet \
        tree \
        unzip \
        valgrind \
        vim \
        wget \
        zip && \
    apt-file update

# Git-specific
git lfs install
curl -o /tmp/hub-linux-amd64-2.2.9.tgz https://github.com/github/hub/releases/download/v2.2.9/hub-linux-amd64-2.2.9.tgz && \
    tar xzf hub-linux-amd64-2.2.9.tgz && \
    /tmp/hub-linux-amd64-2.2.9/install && \
    rm -rf /tmp/hub-linux-amd64-2.2.9 /tmp/hub-linux-amd64-2.2.9.tgz

# Node.js-specific
npm install -g n && n 9.8.0
npm install -g http-server

# Python-specific
pip3 install \
    awscli \
    Flask \
    Flask-Session

# CS50-specific
add-apt-repository ppa:cs50/ppa && \
    apt-get update && \
    apt-get install -y astyle libcs50
pip3 install \
    cs50 \
    check50 \
    help50 \
    render50 \
    style50 \
    submit50

# Bash-specific
cat <<'EOF' > /etc/profile.d/cs50.sh
# File mode creation mask
if [ "$(id -u)" != "0" ]; then
    umask 0077
fi

# Interactive shells
if [ "$PS1" ]; then

    # Prompt
    PS1='\[$(printf "\x0f")\033[01;34m\]\[\033[00m\]$(__git_ps1 " (%s)") $ '

    # Override HOME for cd if ~/workspace exists
    cd()
    {
        if [ -d "$HOME"/sandbox ]; then
            HOME=~/sandbox command cd "$@"
        else
            command cd "$@"
        fi
    }

    # Aliases
    alias cp="cp -i"
    alias ll="ls -l --color=auto"
    alias mv="mv -i"
    alias pip="pip3 --no-cache-dir"
    alias pip3="pip3 --no-cache-dir"
    alias python="python3"
    alias rm="rm -i"

    # Editor
    export EDITOR=nano

fi
EOF

# TODO
useradd --home-dir /root/sandbox --shell /bin/bash ubuntu && \
    umask 0077 && \
    mkdir -p /root/sandbox && \
    chown -R ubuntu:ubuntu /root/sandbox
