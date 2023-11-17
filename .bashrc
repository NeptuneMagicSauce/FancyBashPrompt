#!/bin/sh

# source other files
source ~/.bash_prompt # colors $orange
source ~/.bash_emoji  # get_random_emoji()
source ~/.bash_git    # __git_ps1()

# customisations / user choices
# see color list .bash_prompt
PROMPT_INCLUDE_GIT=1
PROMPT_COLOR_GIT=$lightblue
PROMPT_COLOR_DIRECTORY=$orange
PROMPT_COLOR_CONDA=$green

# git prompt options
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1

# set prompt PS1
# for customisation, see color codes in ~/.bash_prompt
add_prompt_wdir()
{
    PS1+="\[$PROMPT_COLOR_DIRECTORY\]\\w"
    PS1+="\[$reset\]"
}
add_prompt_git()
{
    GITVALUE=`echo $(__git_ps1)`
    if [ ! -z "$GITVALUE" ]; then
        PS1+="\[$PROMPT_COLOR_GIT\]$GITBRANCH$GITVALUE "
    fi
}
add_prompt_emoji()
{
    if [ -n "$INSIDE_EMACS" ]; then
        PS1+=" $ "
    else
        PS1+=" `get_random_emoji` "
    fi
}
set_prompt_all() # slow with msys and cygwin
{
    PS1=""
    add_prompt_git
    add_prompt_wdir
    add_prompt_emoji
}

PROMPT_COMMAND=set_prompt_all

if [ -z $CPUCOUNT ] ; then
    CPUCOUNT=$(nproc)
    export MAKEFLAGS="-j$CPUCOUNT"
fi

LESS+=" -F" # do not paginate if shorter than one screen
LESS+=" -I" # search is case insensitive

# functions
randpassword()
{
    </dev/urandom tr -dc A-Z | head -c 4
    </dev/urandom tr -dc a-z | head -c 4
    </dev/urandom tr -dc 0-9 | head -c 4
    < /dev/urandom tr -dc "!@#$%^\&*\(\)\-_=+[]{}" | head -c 4
    echo ""
}

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# man pages colors https://unix.stackexchange.com/a/147
# not supported by Windows Terminal
export GROFF_NO_SGR=1
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline

# watch interval
export WATCH_INTERVAL=1

# do not remember the dangerous command(s)
export HISTIGNORE='rm *'
export HISTCONTROL=erasedups

# completion : git, docker, ...
if [ -f /usr/share/bash-completion/completions/git ] ; then
#     # ubuntu 22.4
    source /usr/share/bash-completion/completions/git
fi
