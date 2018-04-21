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

# R-specific
# https://www.rstudio.com/products/rstudio/download/#download
#DEBIAN_FRONTEND=noninteractive apt-get install -y libgstreamer1.0-0 libjpeg62 r-base
curl -o /tmp/rstudio-xenial-1.1.447-amd64.deb https://download1.rstudio.org/rstudio-xenial-1.1.447-amd64.deb && \
    (dpkg -i /tmp/rstudio-xenial-1.1.447-amd64.deb || true) && \
    rm -f /tmp/rstudio-xenial-1.1.447-amd64.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get --fix-broken install -y

# CS50-specific
add-apt-repository ppa:cs50/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y astyle libcs50
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

    # Environment variables
    export EDITOR=nano
    export LANG=C
    export LANGUAGE=C.UTF-8
    export LC_ALL=C.UTF-8
    export PATH=/opt/bin:"$PATH"

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
        if [[ "$1" =~ ^--host= || "$1" =~ ^-h[^\s]+ ]]; then
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
    fuser --kill "${port//[^0-9]}/tcp" &> /dev/null

    # spawn flask
    script --flush --quiet --return /dev/null --command "FLASK_APP=\"$FLASK_APP\" FLASK_DEBUG=\"$FLASK_DEBUG\" /usr/local/bin/flask run $host $port $reload $threads $options" |
        while IFS= read -r line
        do
            # rewrite address as hostname50
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
port="8080"
p="-p $port"
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
    elif [[ "$1" =~ ^-p$ ]]; then
        port="$2"
        p="$1 $port"
        shift
        shift
    else
        options+=" $1"
        shift
    fi
done

# kill any process listing on the specified port
fuser --kill "${port//[^0-9]}/tcp" &> /dev/null

# spawn http-server, retaining colorized output
script --flush --quiet --return /dev/null --command "/usr/local/bin/http-server $a $c $cors $i $p $options" |
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

# TODO
useradd --home-dir /root/sandbox --shell /bin/bash ubuntu && \
    umask 0077 && \
    mkdir -p /root/sandbox && \
    chown -R ubuntu:ubuntu /root/sandbox
