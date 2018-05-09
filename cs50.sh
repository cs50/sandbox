# File mode creation mask
if [ "$(id -u)" != "0" ]; then
    umask 0077
fi

# Interactive shells
if [ "$PS1" ]; then

    # Prompt
    PS1='\[$(printf "\x0f")\033[01;34m\]\[\033[00m\]$(__git_ps1 " (%s)")$ '

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
    export PATH=/opt/bin:"$PATH"

fi
