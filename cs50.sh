#!/bin/bash
set -eo pipefail

# Suggested build environment for Python, per pyenv, even though we're building ourselves
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
apt update && \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends --yes \
        make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev llvm ca-certificates curl wget unzip \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Install Python 3.10.x
# https://www.python.org/downloads/
cd /tmp && \
    curl https://www.python.org/ftp/python/3.10.5/Python-3.10.5.tgz --output Python-3.10.5.tgz && \
    tar xzf Python-3.10.5.tgz && \
    rm --force Python-3.10.5.tgz && \
    cd Python-3.10.5 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm --force --recursive Python-3.10.5 && \
    ln --relative --symbolic /usr/local/bin/pip3 /usr/local/bin/pip && \
    ln --relative --symbolic /usr/local/bin/python3 /usr/local/bin/python && \
    pip3 install --upgrade pip

# Install Ruby 3.1.x
# https://www.ruby-lang.org/en/downloads/
cd /tmp && \
    curl https://cache.ruby-lang.org/pub/ruby/3.1/ruby-3.1.2.tar.gz --output ruby-3.1.2.tar.gz && \
    tar xzf ruby-3.1.2.tar.gz && \
    rm --force ruby-3.1.2.tar.gz && \
    cd ruby-3.1.2 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm --force --recursive ruby-3.1.2

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
        clang-8 \
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
        libjpeg8-dev `For Pillow` \
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
        zip

# Git-specific
# https://packagecloud.io/github/git-lfs/install
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash -e && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git-lfs

# Install Java 18.x
# http://jdk.java.net/18/
cd /tmp && \
    wget https://download.java.net/java/GA/jdk18.0.1.1/65ae32619e2f40f3a9af3af1851d6e19/2/GPL/openjdk-18.0.1.1_linux-x64_bin.tar.gz && \
    tar xzf openjdk-18.0.1.1_linux-x64_bin.tar.gz && \
    rm --force openjdk-18.0.1.1_linux-x64_bin.tar.gz && \
    mv jdk-18.0.1.1 /opt/ && \
    mkdir --parent /opt/bin && \
    ln --symbolic /opt/jdk-18.0.1.1/bin/* /opt/bin/ && \
    chmod a+rx /opt/bin/*

# Install Node.js 16.x
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions-enterprise-linux-fedora-and-snap-packages
# https://github.com/nodesource/distributions/blob/master/README.md#debinstall
curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs && \
    npm install -g npm `# Upgrades npm to latest` && \
    npm install -g grunt http-server nodemon

# Install Swift 5.1
cd /tmp && \
    wget https://swift.org/builds/swift-5.1.3-release/ubuntu1804/swift-5.1.3-RELEASE/swift-5.1.3-RELEASE-ubuntu18.04.tar.gz && \
    tar xzf swift-5.1.3-RELEASE-ubuntu18.04.tar.gz --strip-components=1 -C / && \
    rm -f swift-5.1.3-RELEASE-ubuntu18.04.tar.gz && \
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
    github-pages:224 \
    jekyll \
    jekyll-asciidoc \
    pygments.rb

# Lua-specific
# https://askubuntu.com/a/1035151
update-alternatives --install /usr/bin/lua lua-interpreter /usr/bin/lua5.3 130 --slave /usr/share/man/man1/lua.1.gz lua-manual /usr/share/man/man1/lua5.3.1.gz
update-alternatives --install /usr/bin/luac lua-compiler /usr/bin/luac5.3 130 --slave /usr/share/man/man1/luac.1.gz lua-compiler-manual /usr/share/man/man1/luac5.3.1.gz

# LÖVE-specific
# https://github.com/love2d/love/releases
wget -P /tmp https://github.com/love2d/love/releases/download/0.10.2/love_0.10.2ppa1_amd64.deb && \
    wget -P /tmp https://github.com/love2d/love/releases/download/0.10.2/liblove0_0.10.2ppa1_amd64.deb && \
    (dpkg -i /tmp/love_0.10.2ppa1_amd64.deb /tmp/liblove0_0.10.2ppa1_amd64.deb || true) && \
    DEBIAN_FRONTEND=noninteractive apt-get -f install -y && \
    rm -f /tmp/love_0.10.2ppa1_amd64.deb /tmp/liblove0_0.10.2ppa1_amd64.deb

# R-specific
# https://www.rstudio.com/products/rstudio/download-server/
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

# Configure clang 8 last, else 7 takes priority
(update-alternatives --remove-all clang || true) && \
    update-alternatives --install /usr/bin/clang clang $(which clang-8) 1

# Bash-specific
mkdir -p /home/ubuntu/sandbox
mkdir -p /home/ubuntu/.bashrcs
cat <<'EOF' > /home/ubuntu/.bashrcs/~cs50.sh
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
    export JAVA_HOME="/opt/jdk-16.0.2"
    export PYTHONDONTWRITEBYTECODE="1"
    export VALGRIND_OPTS="--memcheck:leak-check=full --memcheck:show-leak-kinds=all --memcheck:track-origins=yes"

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
chmod a+rwx /home/ubuntu/*

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
useradd --home-dir /home/ubuntu/sandbox --shell /bin/bash ubuntu && \
   umask 0077 && \
   mkdir -p /home/ubuntu && \
   chown -R ubuntu:ubuntu /home/ubuntu && \
   echo "ubuntu:crimson" | chpasswd
