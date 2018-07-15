#!/bin/bash

# Ubuntu-specific
apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
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
        npm \
        ocaml \
        perl \
        php7.2-cli \
        php7.2-curl \
        php7.2-gmp \
        php7.2-intl \
        php7.2-mcrypt \
        rpm \
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
# https://packagecloud.io/github/git-lfs/install#manual-deb
# https://github.com/github/hub/releases
DEBIAN_FRONTEND=noninteractive apt-get install -y curl gnupg && \
    curl -L https://packagecloud.io/github/git-lfs/gpgkey | apt-key add - && \
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

# Java-specific
# http://jdk.java.net/10/
wget -P /tmp https://download.java.net/java/GA/jdk10/10.0.1/fb4372174a714e6b8c52526dc134031e/10//openjdk-10.0.1_linux-x64_bin.tar.gz && \
    tar xzf /tmp/openjdk-10.0.1_linux-x64_bin.tar.gz -C /tmp && \
    rm -f /tmp/openjdk-10.0.1_linux-x64_bin.tar.gz && \
    mv /tmp/jdk-10.0.1 /opt/ && \
    mkdir -p /opt/bin && \
    ln -s /opt/jdk-10.0.1/bin/* /opt/bin/ && \
    chmod a+rx /opt/bin/*

# LÖVE-specific
# https://bitbucket.org/rude/love/downloads/
wget -P /tmp https://bitbucket.org/rude/love/downloads/love_0.10.2ppa1_amd64.deb && \
    wget -P /tmp https://bitbucket.org/rude/love/downloads/liblove0_0.10.2ppa1_amd64.deb && \
    (dpkg -i /tmp/love_0.10.2ppa1_amd64.deb /tmp/liblove0_0.10.2ppa1_amd64.deb || true) && \
    DEBIAN_FRONTEND=noninteractive apt-get -f install -y && \
    rm -f /tmp/love_0.10.2ppa1_amd64.deb /tmp/liblove0_0.10.2ppa1_amd64.deb

# Node.js-specific
npm install -g http-server n && n 10.6.0

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
    mv /tmp/pyenv-master "$PYENV_ROOT" && \
    chmod a+x "$PYENV_ROOT"/bin/pyenv && \
    "$PYENV_ROOT"/bin/pyenv install 2.7.15 && \
    "$PYENV_ROOT"/bin/pyenv install 3.7.0 && \
    "$PYENV_ROOT"/bin/pyenv rehash && \
    "$PYENV_ROOT"/bin/pyenv global 2.7.15 3.7.0 &&
    "$PYENV_ROOT"/shims/pip2 install --upgrade pip==9.0.3 && \
    "$PYENV_ROOT"/shims/pip3 install --upgrade pip==9.0.3 && \
    "$PYENV_ROOT"/shims/pip3 install \
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
    mv /tmp/rbenv-master "$RBENV_ROOT" && \
    chmod a+x "$RBENV_ROOT"/bin/rbenv && \
    wget -P /tmp https://github.com/rbenv/ruby-build/archive/master.zip && \
    unzip -d /tmp /tmp/master.zip && \
    rm -f /tmp/master.zip && \
    mkdir "$RBENV_ROOT"/plugins && \
    mv /tmp/ruby-build-master "$RBENV_ROOT"/plugins/ruby-build && \
    "$RBENV_ROOT"/bin/rbenv install 2.5.1 && \
    "$RBENV_ROOT"/bin/rbenv rehash && \
    "$RBENV_ROOT"/bin/rbenv global 2.5.1
PATH="$RBENV_ROOT"/shims:"$RBENV_ROOT"/bin:"$PATH" gem install \
        asciidoctor \
        bundler \
        fpm \
        jekyll-asciidoc \
        pygments.rb

# R-specific
# https://www.rstudio.com/products/rstudio/download/#download
echo "deb https://cran.cnr.berkeley.edu/bin/linux/ubuntu xenial/" > /etc/apt/sources.list.d/cran.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y r-base && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y gdebi-core && \
    wget -P /tmp https://download2.rstudio.org/rstudio-server-1.1.453-amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive /tmp/rstudio-server-1.1.453-amd64.deb && \
    rm -f /tmp/rstudio-server-1.1.453-amd64.deb && \
    echo "server-app-armor-enabled=0" >> /etc/rstudio/rserver.conf && \
    echo "www-frame-origin=any" >> /etc/rstudio/rserver.conf && \
    echo "session-timeout-minutes=0" >> /etc/rstudio/rsession.conf
cat <<'EOF' > /etc/rstudio/login.html
<script>

    window.onload = function() {
        document.getElementById('username').value = 'ubuntu';
        document.getElementById('password').value = 'crimson';
        var p = document.querySelectorAll('#border p');
        for (var i = 0; i < p.length; i++) {
            p[i].style.display = 'none';
        }
    }

</script>
EOF

# CS50-specific
add-apt-repository -y ppa:cs50/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y astyle libcs50
"$PYENV_ROOT"/shims/pip3 install \
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
export PATH=/opt/cs50/bin:/opt/bin:/usr/local/sbin:/usr/local/bin:"$RBENV_ROOT"/shims:"$RBENV_ROOT"/bin:"$PYENV_ROOT"/shims:"$PYENV_ROOT"/bin:/usr/sbin:/usr/bin:/sbin:/bin

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

# /opt/cs50/bin
mkdir -p /opt/cs50/bin
cat <<'EOF' > /opt/cs50/bin/flask
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
cat <<'EOF' > /opt/cs50/bin/http-server
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
chmod a+rx /opt/cs50/bin/*

# Ubuntu-specific
useradd --home-dir /home/ubuntu --shell /bin/bash ubuntu && \
    umask 0077 && \
    mkdir -p /home/ubuntu && \
    chown -R ubuntu:ubuntu /home/ubuntu && \
    echo "ubuntu:crimson" | chpasswd
