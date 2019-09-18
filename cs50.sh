#!/bin/bash
set -e

# Install Python 3.7
# https://www.python.org/downloads/
# https://stackoverflow.com/a/44758621/5156190
apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        libbz2-dev \
        libc6-dev \
        libgdbm-dev \
        libncursesw5-dev \
        libreadline-gplv2-dev \
        libsqlite3-dev \
        libssl-dev \
        tk-dev \
        zlib1g-dev && \
    cd /tmp && \
    wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz && \
    tar xzf Python-3.7.3.tgz && \
    rm -f Python-3.7.3.tgz && \
    cd Python-3.7.3 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf Python-3.7.3 && \
    pip3 install --upgrade pip

# Ubuntu-specific
apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        apt-file \
        apt-transport-https \
        apt-utils \
        bash-completion \
        bc \
        bsdtar \
        build-essential \
        clang-6.0 \
        cmake \
        composer \
        curl \
        dnsutils \
        dos2unix \
        erlang \
        exiftool \
        expect `# For unbuffer` \
        gdb \
        gettext \
        git \
        golang \
        haskell-platform \
        imagemagick \
        info \
        lua5.3 \
        luarocks \
        man \
        mysql-client \
        nano \
        ocaml \
        octave \
        perl \
        php7.2-cli \
        php7.2-curl \
        php7.2-gmp \
        php7.2-intl \
        rpm \
        ruby \
        ruby-dev `# Avoid "can't find header files for ruby" for gem` \
        s3cmd \
        sqlite3 \
        swi-prolog \
        telnet \
        tk-dev \
        tree \
        unzip \
        valgrind \
        vim \
        wget \
        zip && \
    update-alternatives --install /usr/bin/clang clang $(which clang-6.0) 1 && \
    apt-file update

# Git-specific
# https://packagecloud.io/github/git-lfs/install
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash -e && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git-lfs

# Install Java 12
# http://jdk.java.net/12/
cd /tmp && \
    wget https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_linux-x64_bin.tar.gz && \
    tar xzf openjdk-12.0.1_linux-x64_bin.tar.gz && \
    rm -f openjdk-12.0.1_linux-x64_bin.tar.gz && \
    mv jdk-12.0.1 /opt/ && \
    mkdir -p /opt/bin && \
    ln -s /opt/jdk-12.0.1/bin/* /opt/bin/ && \
    chmod a+rx /opt/bin/*

# Lua-specific
# https://askubuntu.com/a/1035151
update-alternatives --install /usr/bin/lua lua-interpreter /usr/bin/lua5.3 130 --slave /usr/share/man/man1/lua.1.gz lua-manual /usr/share/man/man1/lua5.3.1.gz
update-alternatives --install /usr/bin/luac lua-compiler /usr/bin/luac5.3 130 --slave /usr/share/man/man1/luac.1.gz lua-compiler-manual /usr/share/man/man1/luac5.3.1.gz

# LÖVE-specific
# https://bitbucket.org/rude/love/downloads/
wget -P /tmp https://bitbucket.org/rude/love/downloads/love_0.10.2ppa1_amd64.deb && \
    wget -P /tmp https://bitbucket.org/rude/love/downloads/liblove0_0.10.2ppa1_amd64.deb && \
    (dpkg -i /tmp/love_0.10.2ppa1_amd64.deb /tmp/liblove0_0.10.2ppa1_amd64.deb || true) && \
    DEBIAN_FRONTEND=noninteractive apt-get -f install -y && \
    rm -f /tmp/love_0.10.2ppa1_amd64.deb /tmp/liblove0_0.10.2ppa1_amd64.deb

# Install Node.js 12.x
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions-enterprise-linux-fedora-and-snap-packages
# https://github.com/nodesource/distributions/blob/master/README.md#debinstall
curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs && \
    npm install -g npm `# Upgrades npm to latest` && \
    npm install -g grunt http-server nodemon

# Install Swift 5.0
cd /tmp && \
    wget https://swift.org/builds/swift-5.0.2-release/ubuntu1804/swift-5.0.2-RELEASE/swift-5.0.2-RELEASE-ubuntu18.04.tar.gz && \
    tar xzf swift-5.0.2-RELEASE-ubuntu18.04.tar.gz --strip-components=1 -C / && \
    rm -f swift-5.0.2-RELEASE-ubuntu18.04.tar.gz && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libpython2.7

# Install CS50 packages
pip3 install \
        check50 \
        cs50 \
        Flask \
        Flask-Session \
        style50 \
        submit50
pip3 install \
        awscli \
        compare50 \
        help50 \
        matplotlib \
        numpy \
        pandas \
        render50 \
        submit50 \
        virtualenv

# Install Heroku CLI
curl https://cli-assets.heroku.com/install.sh | sh

# Install fpm, asciidoctor
# https://github.com/asciidoctor/jekyll-asciidoc/issues/135#issuecomment-241948040
# https://github.com/asciidoctor/jekyll-asciidoc#development
gem install \
    asciidoctor \
    bundler \
    fpm \
    github-pages \
    jekyll \
    jekyll-asciidoc \
    pygments.rb

# R-specific
# https://www.rstudio.com/products/rstudio/download-server/
mkdir -p /root/sandbox
echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" > /etc/apt/sources.list.d/cran.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y r-base && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y gdebi-core && \
    wget -P /tmp https://download2.rstudio.org/rstudio-server-1.1.456-amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive /tmp/rstudio-server-1.1.456-amd64.deb && \
    rm -f /tmp/rstudio-server-1.1.456-amd64.deb && \
    echo "server-app-armor-enabled=0" >> /etc/rstudio/rserver.conf && \
    echo "www-frame-origin=any" >> /etc/rstudio/rserver.conf && \
    echo "session-timeout-minutes=1" >> /etc/rstudio/rsession.conf
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
curl -s https://packagecloud.io/install/repositories/cs50/repo/script.deb.sh | bash -e && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y astyle libcs50 libcs50-java php-cs50

# Bash-specific
mkdir -p /root/.bashrcs
cat <<'EOF' > /root/.bashrcs/~cs50.sh
# File mode creation mask
if [ "$(id -u)" != "0" ]; then
    umask 0077
fi

# PATH
export PATH=/opt/cs50/bin:"$HOME"/.local/bin:/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Interactive shells
if [ "$PS1" ]; then

    # Simplify prompt
    export PS1='$ '

    # Override HOME for cd if ~/sandbox exists
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
    alias ls="ls --color=auto -F"
    alias ll="ls -F -l"
    alias mv="mv -i"
    alias pip="pip3 --no-cache-dir"
    alias pip3="pip3 --no-cache-dir"
    alias python="python3"
    alias rm="rm -i"
    alias swift="swift 2> /dev/null"  # https://github.com/cs50/sandbox/issues/26

    # Environment variables
    export CC="clang"
    export CFLAGS="-fsanitize=signed-integer-overflow -fsanitize=undefined -ggdb3 -O0 -std=c11 -Wall -Werror -Wextra -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable -Wshadow"
    export CLASSPATH=".:/usr/share/java/cs50.jar"
    export EDITOR=nano
    export FLASK_APP=application.py
    export FLASK_ENV=development
    export LANG=C
    export LANGUAGE=C.UTF-8
    export LC_ALL=C.UTF-8
    export LDLIBS="-lcrypt -lcs50 -lm"
    export JAVA_HOME="/opt/jdk-12"
    export PYTHONDONTWRITEBYTECODE="1"
    export VALGRIND_OPTS="--memcheck:leak-check=full --memcheck:track-origins=yes"

    # History
    # https://www.shellhacks.com/tune-command-line-history-bash/
    shopt -s histappend  # Append Bash Commands to History File
    export PROMPT_COMMAND='history -a'  # Store Bash History Immediately
    shopt -s cmdhist  # Use one command per line
    if [ "$(id -u)" == "0" ]; then
        export HISTFILE=~/sandbox/.bash_history  # Change the History File Name
    fi

    # make
    make () {
        local args=""
        local invalid_args=0

        for arg; do
            case "$arg" in
                (*.c) arg=${arg%.c}; invalid_args=1;;
            esac
            args="$args $arg"
        done

        if [ $invalid_args -eq 1 ]; then
            echo "Did you mean 'make$args'?"
            return 1
        else
            command make -B $*
        fi
    }
fi

# cmd
EOF

# /opt/cs50/bin
mkdir -p /opt/cs50/bin
cat <<'EOF' > /opt/cs50/bin/flask
#!/bin/bash

if [[ "$1" == "run" ]]; then

    # Default options
    host="--host=0.0.0.0"
    port="--port=8080"
    reload="--reload"

    # Override default options
    options=""
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

    # Kill any process listing on the specified port
    # using regex to handle -pxxxx, -p xxxx, --port xxxx, --port=xxxx
    fuser --kill -INT "${port//[^0-9]}/tcp" &> /dev/null

    # Spawn flask
    FLASK_APP="$FLASK_APP" FLASK_DEBUG="${FLASK_DEBUG:-0}" unbuffer /usr/local/bin/flask run $host $port $reload $threads $options | sed "s#\(.*http://\)[^:]\+\(:.\+\)#\1localhost\2#"
else
    /usr/local/bin/flask "$@"
fi
EOF
cat <<'EOF' > /opt/cs50/bin/http-server
#!/bin/bash
# Default options
a="-a 0.0.0.0"
c="-c-1"
cors="--cors"
i="-i false"
port="-p 8080"
options="--no-dotfiles"
# Override default options
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
# Kill any process listing on the specified port
# using regex to handle -pxxxx, -p xxxx, --port xxxx, --port=xxxx
fuser --kill "${port//[^0-9]}/tcp" &> /dev/null
# Spawn http-server, retaining colorized output using expect's unbuffer
unbuffer "$(npm prefix -g)/bin/http-server" $a $c $cors $i $port $options | unbuffer -p sed "s#\(.*http://\)[^:]\+\(:.\+\)#\1localhost\2#" | uniq
EOF
chmod a+rx /opt/cs50/bin/*

# Ubuntu-specific
#useradd --home-dir /home/ubuntu --shell /bin/bash ubuntu && \
#    umask 0077 && \
#    mkdir -p /home/ubuntu && \
#    chown -R ubuntu:ubuntu /home/ubuntu && \
#    echo "ubuntu:crimson" | chpasswd
