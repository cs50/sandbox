FROM ubuntu:17.10

# Ubuntu-specific
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        apt-file \
        apt-transport-https \
        apt-utils \
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
        ocaml \
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
RUN git lfs install
RUN curl -L -o /tmp/hub-linux-amd64-2.2.9.tgz -s https://github.com/github/hub/releases/download/v2.2.9/hub-linux-amd64-2.2.9.tgz && \
    tar xzf /tmp/hub-linux-amd64-2.2.9.tgz -C /tmp && \
    /tmp/hub-linux-amd64-2.2.9/install && \
    rm -rf /tmp/hub-linux-amd64-2.2.9 /tmp/hub-linux-amd64-2.2.9.tgz

# Node.js-specific
RUN npm install -g http-server n && n 10.0.0

# Python-specific
RUN pip3 install \
    awscli \
    Flask \
    Flask-Session

# R-specific
# https://www.rstudio.com/products/rstudio/download/#download
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libgstreamer1.0-0 libjpeg62 libxslt-dev r-base
RUN curl -L -o /tmp/rstudio-xenial-1.1.447-amd64.deb -s https://download1.rstudio.org/rstudio-xenial-1.1.447-amd64.deb && \
    (dpkg -i /tmp/rstudio-xenial-1.1.447-amd64.deb || true) && \
    rm -f /tmp/rstudio-xenial-1.1.447-amd64.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get --fix-broken install -y

# CS50-specific
RUN add-apt-repository ppa:cs50/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y astyle libcs50
RUN pip3 install \
    cs50 \
    check50 \
    help50 \
    render50 \
    style50 \
    submit50

# Bash-specific
COPY cs50.sh /etc/profile.d/

# /opt/bin
RUN mkdir -p /opt/bin
COPY flask http-server /opt/bin/
RUN chmod a+rx /opt/bin/*

# TODO
RUN useradd --home-dir /root/sandbox --shell /bin/bash ubuntu && \
    umask 0077 && \
    mkdir -p /root/sandbox && \
    chown -R ubuntu:ubuntu /root/sandbox
CMD bash -l
