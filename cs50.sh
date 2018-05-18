#!/bin/bash

# Ubuntu-specific
apt-get update && \
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
        imagemagick \
        info \
        man \
        mysql-client \
        nano \
        nodejs \
        ocaml \
        openjdk-9-jre \
        perl \
        php-cli \
        php-curl \
        php-gmp \
        php-intl \
        php-mcrypt \
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
        DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-overwrite" install openjdk-9-jdk `# https://askubuntu.com/a/772485` && \
    apt-file update

# Git-specific
# https://packagecloud.io/github/git-lfs/install#manual-deb
# https://github.com/github/hub/releases
DEBIAN_FRONTEND=noninteractive apt-get install -y curl gnupg && \
    curl -L https://packagecloud.io/github/git-lfs/gpgkey | apt-key add -y - && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y debian-archive-keyring && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https && \
    echo "deb https://packagecloud.io/github/git-lfs/ubuntu/ xenial main" > /etc/apt/sources.list.d/github_git-lfs.list && \
    echo "deb-src https://packagecloud.io/github/git-lfs/ubuntu/ xenial main" >> /etc/apt/sources.list.d/github_git-lfs.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git-lfs && \
    git lfs install
curl -L -o /tmp/hub-linux-amd64-2.2.9.tgz -s https://github.com/github/hub/releases/download/v2.2.9/hub-linux-amd64-2.2.9.tgz && \
    tar xzf /tmp/hub-linux-amd64-2.2.9.tgz -C /tmp && \
    /tmp/hub-linux-amd64-2.2.9/install && \
    rm -rf /tmp/hub-linux-amd64-2.2.9 /tmp/hub-linux-amd64-2.2.9.tgz

# Node.js-specific
npm install -g http-server n && n 10.0.0

# Python-specific
# https://github.com/yyuu/pyenv/blob/master/README.md#installation
# https://github.com/yyuu/pyenv/wiki/Common-build-problems
export PYENV_ROOT=/opt/pyenv
DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        curl \
        libbz2-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        llvm \
        wget \
        xz-utils \
        zlib1g-dev && \
    wget -P /tmp https://github.com/yyuu/pyenv/archive/master.zip && \
    unzip -d /tmp /tmp/master.zip && \
    rm -f /tmp/master.zip && \
    mv /tmp/pyenv-master /opt/pyenv && \
    chmod a+x /opt/pyenv/bin/pyenv && \
    /opt/pyenv/bin/pyenv install 3.6.0 && \
    /opt/pyenv/bin/pyenv rehash && \
    /opt/pyenv/bin/pyenv global 3.6.0
PATH="$PYENV_ROOT"/shims:"$PYENV_ROOT"/bin:"$PATH" pip install --upgrade pip
PATH="$PYENV_ROOT"/shims:"$PYENV_ROOT"/bin:"$PATH" pip install --upgrade pip install \
        awscli \
        Flask \
        Flask-Session

# Ruby-specific
# https://github.com/rbenv/rbenv/blob/master/README.md#installation
# https://github.com/rbenv/ruby-build/blob/master/README.md
export RBENV_ROOT=/opt/rbenv
DEBIAN_FRONTEND=noninteractive apt-get install -y libreadline-dev zlib1g-dev && \
    wget -P /tmp https://github.com/rbenv/rbenv/archive/master.zip && \
    unzip -d /tmp /tmp/master.zip && \
    rm -f /tmp/master.zip && \
    mv /tmp/rbenv-master /opt/rbenv && \
    chmod a+x /opt/rbenv/bin/rbenv && \
    wget -P /tmp https://github.com/rbenv/ruby-build/archive/master.zip && \
    unzip -d /tmp /tmp/master.zip && \
    rm -f /tmp/master.zip && \
    mkdir /opt/rbenv/plugins && \
    mv /tmp/ruby-build-master /opt/rbenv/plugins/ruby-build && \
    /opt/rbenv/bin/rbenv install 2.4.0 && \
    /opt/rbenv/bin/rbenv rehash && \
    /opt/rbenv/bin/rbenv global 2.4.0
PATH="$RBENV_ROOT"/shims:"$RBENV_ROOT"/bin:"$PATH" gem install \
        asciidoctor \
        bundler \
        fpm \
        jekyll-asciidoc \
        pygments.rb

# R-specific
# https://www.rstudio.com/products/rstudio/download/#download
DEBIAN_FRONTEND=noninteractive apt-get install -y libgstreamer1.0-0 libjpeg62 libxslt-dev r-base
curl -L -o /tmp/rstudio-xenial-1.1.447-amd64.deb -s https://download1.rstudio.org/rstudio-xenial-1.1.447-amd64.deb && \
    (dpkg -i /tmp/rstudio-xenial-1.1.447-amd64.deb || true) && \
    rm -f /tmp/rstudio-xenial-1.1.447-amd64.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get --fix-broken install -y

# CS50-specific
add-apt-repository -y ppa:cs50/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y astyle libcs50
PATH="$PYENV_ROOT"/shims:"$PYENV_ROOT"/bin:"$PATH" pip install \
        cs50 \
        check50 \
        help50 \
        render50 \
        style50 \
        submit50

# Bash-specific
mkdir -p /root/.bashrcs
cat <<'EOF' > /root/.bashrcs/cs50.sh
# File mode creation mask
if [ "$(id -u)" != "0" ]; then
    umask 0077
fi

# PATH
export RBENV_ROOT=/opt/rbenv
export PYENV_ROOT=/opt/pyenv
export PATH=/opt/cs50/bin:/usr/local/sbin:/usr/local/bin:"$RBENV_ROOT"/shims:"$RBENV_ROOT"/bin:"$PYENV_ROOT"/shims:"$PYENV_ROOT"/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Interactive shells
if [ "$PS1" ]; then

    # Simplify prompt

    export PS1='$ '
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
    alias gdb="gdb -q"
    alias ll="ls -l --color=auto"
    alias make="make -B"
    alias mv="mv -i"
    alias pip="pip3 --no-cache-dir"
    alias pip3="pip3 --no-cache-dir"
    alias python="python3"
    alias rm="rm -i"

    # Environment variables
    export CC="clang"
    export CFLAGS="-fsanitize=signed-integer-overflow -fsanitize=undefined -ggdb3 -O0 -std=c11 -Wall -Werror -Wextra -Wno-sign-compare -Wshadow"
    export EDITOR=nano
    export FLASK_ENV=development
    export LANG=C
    export LANGUAGE=C.UTF-8
    export LC_ALL=C.UTF-8
    export LDLIBS="-lcrypt -lcs50 -lm"

fi
EOF

# /opt/bin
mkdir -p /opt/bin
cat <<'EOF' > /opt/bin/flask
#!/bin/bash

# flask run
if [[ "$1" == "run" ]]; then

    # otherwise FLASK_DEBUG=1 suppresses this error in shell
    if [[ ! -z "$FLASK_APP" && ! -f "$FLASK_APP" ]]; then
        echo "Usage: flask run [OPTIONS]"
        echo
        echo "Error: The file/path provided ($FLASK_APP) does not appear to exist.  Please verify the path is correct.  If app is not on PYTHONPATH, ensure the extension is .py"
        exit 1
    fi

    # default options
    debugger="--no-debugger"
    host="--host=0.0.0.0"
    port="--port=5000"
    reload="--reload"

    # remove when https://github.com/miguelgrinberg/Flask-SocketIO/pull/659 is merged
    if /usr/local/bin/flask run --help | grep --quiet -- "--with-threads"; then
        threads="--with-threads";
    fi

    options=""

    # override default options
    shift
    while test ${#} -gt 0
    do
        if [[ "$1" =~ ^--(no-)?debugger$ ]]; then
            debugger="$1"
        elif [[ "$1" =~ ^--host= || "$1" =~ ^-h[^\s]+ ]]; then
            host="$1"
        elif [[ "$1" == "-h" || "$1" == "--host" ]]; then
            host="$1 $2"
            shift
        elif [[ "$1" =~ ^--port= || "$1" =~ ^-p[^\s]+ ]]; then
            port="$1"
        elif [[ "$1" == "-p" || "$1" == "--port"  ]]; then
            port="$1 $2"
            shift
        elif [[ "$1" =~ ^--(no-)?reload$ ]]; then
            reload="$1"
        elif [[ "$1" =~ ^--with(out)?-threads$ ]]; then
            threads="$1"
        else
            options+=" $1"
        fi
        shift
    done

    # kill any process listing on the specified port
    # regex to handle -pxxxx, -p xxxx, --port xxxx, --port=xxxx
    fuser --kill "${port//[^0-9]}/tcp" &> /dev/null

    # spawn flask
    script --flush --quiet --return /dev/null --command "FLASK_APP=\"$FLASK_APP\" FLASK_DEBUG=\"$FLASK_DEBUG\" /usr/local/bin/flask run $debugger $host $port $reload $threads $options" |
        while IFS= read -r line
        do
            # rewrite address as localhost
            echo "$line" | sed "s#\( *Running on http://\)[^:]\+\(:.\+\)#\1localhost\2#"
        done
else
    /usr/local/bin/flask "$@"
fi
EOF
cat <<'EOF' > /opt/bin/http-server
#!/bin/bash

# default options
a="-a 0.0.0.0"
c="-c-1"
cors="--cors"
i="-i false"
port="-p 8080"
options="--no-dotfiles"

# override default options
while test ${#} -gt 0
do
    if [[ "$1" =~ ^-a$ ]]; then
        a="$1 $2"
        shift
        shift
    elif [[ "$1" =~ ^-c-?[0-9]+$ ]]; then
        c="$1"
        shift
    elif [[ "$1" =~ ^--cors(=.*)?$ ]]; then
        cors="$1"
        shift
    elif [[ "$1" =~ ^-i$ ]]; then
        i="$1 $2"
        shift
        shift
    elif [[ "$1" =~ ^-p[^\s]+ ]]; then
        port="$1"
        shift
    elif [[ "$1" == "-p" ]]; then
        port="$1 $2"
        shift
        shift
    else
        options+=" $1"
        shift
    fi
done

# kill any process listing on the specified port
# regex to handle -pxxxx, -p xxxx
fuser --kill "${port//[^0-9]}/tcp" &> /dev/null

# spawn http-server, retaining colorized output
script --flush --quiet --return /dev/null --command "/usr/local/bin/http-server $a $c $cors $i $port $options" |
    while IFS= read -r line
    do
        # rewrite address(es) as localhost
        if [[ "$line" =~ "Available on:" ]]; then
            echo "$line"
            IFS= read -r line
            echo "$line" | sed "s#\(.*http://\)[^:]\+\(:.\+\)#\1localhost\2#"
            while IFS= read -r line
            do
                if [[ "$line" =~ "Hit CTRL-C to stop the server" ]]; then
                    echo "$line"
                    break
                fi
            done
        else
            echo "$line"
        fi
    done
EOF
chmod a+rx /opt/bin/*

# Ubuntu-specific
useradd --home-dir /home/ubuntu --shell /bin/bash ubuntu && \
    umask 0077 && \
    mkdir -p /home/ubuntu && \
    chown -R ubuntu:ubuntu /home/ubuntu
