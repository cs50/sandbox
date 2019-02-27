#!/bin/bash
set -e

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
        clang \
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
        openjdk-11-jdk-headless `# Java 10` \
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
    apt-file update

# Git-specific
# https://packagecloud.io/github/git-lfs/install
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash -e && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git-lfs

# Java-specific
# http://jdk.java.net/10/
wget -P /tmp https://download.java.net/java/GA/jdk10/10.0.1/fb4372174a714e6b8c52526dc134031e/10//openjdk-10.0.1_linux-x64_bin.tar.gz && \
    tar xzf /tmp/openjdk-10.0.1_linux-x64_bin.tar.gz -C /tmp && \
    rm -f /tmp/openjdk-10.0.1_linux-x64_bin.tar.gz && \
    mv /tmp/jdk-10.0.1 /opt/ && \
    mkdir -p /opt/bin && \
    ln -s /opt/jdk-10.0.1/bin/* /opt/bin/ && \
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

# Node.js-specific
curl -sL https://deb.nodesource.com/setup_11.x | bash - && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs && \
    npm install -g npm && \
    npm install -g http-server

# Python-specific
# https://github.com/yyuu/pyenv/blob/master/README.md#installation
# https://github.com/yyuu/pyenv/wiki/Common-build-problems
export PYENV_ROOT=/opt/pyenv
DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        curl \
        libbz2-dev \
        libffi-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        llvm \
        make \
        tk-dev \
        wget \
        xz-utils \
        zlib1g-dev && \
    wget -P /tmp https://github.com/pyenv/pyenv/archive/master.zip && \
    unzip -d /tmp /tmp/master.zip && \
    rm -f /tmp/master.zip && \
    mv /tmp/pyenv-master "$PYENV_ROOT" && \
    chmod a+x "$PYENV_ROOT"/bin/* && \
    "$PYENV_ROOT"/bin/pyenv install 2.7.15 && \
    "$PYENV_ROOT"/bin/pyenv install 3.7.1 && \
    "$PYENV_ROOT"/bin/pyenv rehash && \
    "$PYENV_ROOT"/bin/pyenv global 2.7.15 3.7.1 &&
    "$PYENV_ROOT"/shims/pip2 install --upgrade pip && \
    "$PYENV_ROOT"/shims/pip3 install --upgrade pip && \
    "$PYENV_ROOT"/shims/pip3 install \
        awscli \
        Flask \
        Flask-Session

# Ruby-specific
gem install \
    asciidoctor \
    bundler \
    fpm \
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
"$PYENV_ROOT"/shims/pip3 install \
        cs50 \
        help50 \
        render50 \
        style50

"$PYENV_ROOT"/shims/pip3 install --upgrade 'check50<3' 'submit50<3'

# Bash-specific
mkdir -p /root/.bashrcs
cat <<'EOF' > /root/.bashrcs/~cs50.sh
# File mode creation mask
if [ "$(id -u)" != "0" ]; then
    umask 0077
fi

# PATH
export PYENV_ROOT=/opt/pyenv
export PATH=/opt/cs50/bin:"$HOME"/.local/bin:"$PYENV_ROOT"/shims:"$PYENV_ROOT"/bin:/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

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
    alias mv="mv -i"
    alias pip="pip3 --no-cache-dir"
    alias pip3="pip3 --no-cache-dir"
    alias python="python3"
    alias rm="rm -i"

    # Environment variables
    export CC="clang"
    export CFLAGS="-fsanitize=signed-integer-overflow -fsanitize=undefined -ggdb3 -O0 -std=c11 -Wall -Werror -Wextra -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable -Wshadow"
    export EDITOR=nano
    export FLASK_APP=application.py
    export FLASK_ENV=development
    export LANG=C
    export LANGUAGE=C.UTF-8
    export LC_ALL=C.UTF-8
    export LDLIBS="-lcrypt -lcs50 -lm"
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
    FLASK_APP="$FLASK_APP" FLASK_DEBUG="${FLASK_DEBUG:-0}" unbuffer /opt/pyenv/shims/flask run $host $port $reload $threads $options | sed "s#\(.*http://\)[^:]\+\(:.\+\)#\1localhost\2#"
else
    /opt/pyenv/shims/flask "$@"
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
useradd --home-dir /home/ubuntu --shell /bin/bash ubuntu && \
    umask 0077 && \
    mkdir -p /home/ubuntu && \
    chown -R ubuntu:ubuntu /home/ubuntu && \
    echo "ubuntu:crimson" | chpasswd
