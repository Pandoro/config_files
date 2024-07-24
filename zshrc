# Environment
#export TERM="rxvt"
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
export LESSHISTFILE="-"
export PAGER="less"
export READNULLCMD="${PAGER}"
export VISUAL="vim"
export EDITOR="${VISUAL}"
export VIEWER="xpdf"
export BROWSER="firefox"
export XTERM="urxvt"

# Manual pages
# - colorize, since man-db fails to do so
export LESS_TERMCAP_mb=$'\E[01;31m'   # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'   # begin bold
export LESS_TERMCAP_me=$'\E[0m'       # end mode
export LESS_TERMCAP_se=$'\E[0m'       # end standout-mode
export LESS_TERMCAP_so=$'\E[1;33;40m' # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'       # end underline
export LESS_TERMCAP_us=$'\E[1;32m'    # begin underline


# Aliases
alias open="xdg-open"
alias ..="cd .."
alias ...="cd ../.."
alias ls="ls -aF --color=always"
alias ll="ls -l"
alias grep="grep --color=always"
alias mv="mv -i"
alias rm="rm -i"
alias top="htop"
alias df="df -hT"
alias du="du -hc"
alias su="su - "
alias calc="bc -l <<<"
alias sq="squeue -a -S -T --format=\"%.6i %.10j %.14u %.10b %.6C %.12m %.12M %.12l %.10N %.15P %.10T\""

# ZSH settings
setopt nohup
setopt autocd
setopt cdablevars
setopt nobgnice
setopt nobanghist
setopt clobber
#setopt shwordsplit
#setopt interactivecomments
setopt autopushd pushdminus pushdsilent pushdtohome
setopt histreduceblanks histignorespace inc_append_history

# Prompt requirements
setopt extended_glob prompt_subst
autoload colors zsh/terminfo

# New style completion system
autoload -U compinit; compinit
#  * List of completers to use
zstyle ":completion:*" completer _complete _match _approximate
#  * Allow approximate
zstyle ":completion:*:match:*" original only
zstyle ":completion:*:approximate:*" max-errors 1 numeric
#  * Selection prompt as menu
zstyle ":completion:*" menu select=1
#  * Menu selection for PID completion
zstyle ":completion:*:*:kill:*" menu yes select
zstyle ":completion:*:kill:*" force-list always
zstyle ":completion:*:processes" command "ps -au$USER"
zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#)*=0=01;32"
#  * Don't select parent dir on cd
#zstyle ":completion:*:cd:*" ignore-parents parent pwd
#  * Complete with colors
zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}
# }}}


# {{{ Functions
function extract () {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tbz2 | *.tar.bz2) tar -xvjf  "$1"     ;;
            *.txz | *.tar.xz)   tar -xvJf  "$1"     ;;
            *.tgz | *.tar.gz)   tar -xvzf  "$1"     ;;
            *.tar | *.cbt)      tar -xvf   "$1"     ;;
            *.zip | *.cbz)      unzip      "$1"     ;;
            *.rar | *.cbr)      unrar x    "$1"     ;;
            *.arj)              unarj x    "$1"     ;;
            *.ace)              unace x    "$1"     ;;
            *.bz2)              bunzip2    "$1"     ;;
            *.xz)               unxz       "$1"     ;;
            *.gz)               gunzip     "$1"     ;;
            *.7z)               7z x       "$1"     ;;
            *.Z)                uncompress "$1"     ;;
            *.gpg)       gpg2 -d "$1" | tar -xvzf - ;;
            *) echo 'Error: failed to extract "$1"' ;;
        esac
    else
        echo 'Error: "$1" is not a valid file for extraction'
    fi
}

# Small util to open a pdf remotly to allow easy printing
function remote_pdf () {
    TMP_FN=$(cat /dev/urandom | tr -dc '0-9a-zA-Z' | head -c20)
    scp "$1" einhorn:/tmp/$TMP_FN
    ssh einhorn okular /tmp/$TMP_FN
}

# {{{ Terminal and prompt
function precmd {
    # Terminal width = width - 1 (for lineup)
    local TERMWIDTH
    ((TERMWIDTH=${COLUMNS} - 4))

    # Truncate long paths
    PR_FILLBAR=""
    PR_PWDLEN=""
    local PROMPTSIZE="${#${(%):---(%n@%m:%*)---()--}}"
    local PWDSIZE="${#${(%):-%~}}"
    if [ -n "$VIRTUAL_ENV" ];
    then
        VIRTUAL_ENV_NAME="(`basename $VIRTUAL_ENV`)"
    else
        VIRTUAL_ENV_NAME=""
    fi
    if [ -n "$CONDA_DEFAULT_ENV" ];
    then
        CONDA_ENV_NAME="(`basename $CONDA_DEFAULT_ENV`)"
    else
        CONDA_ENV_NAME=""
    fi
    local VIRTUAL_ENV_SIZE=${#VIRTUAL_ENV_NAME}
    local CONDA_ENV_SIZE=${#CONDA_ENV_NAME}
    if [[ "${PROMPTSIZE} + ${PWDSIZE}" -gt ${TERMWIDTH} ]]; then
	((PR_PWDLEN=${TERMWIDTH} - ${PROMPTSIZE}))
    else
        PR_FILLBAR="\${(l.((${TERMWIDTH} - (${PROMPTSIZE} + ${PWDSIZE} + ${VIRTUAL_ENV_SIZE} + ${CONDA_ENV_SIZE})))..${PR_HBAR}.)}"
    fi
}

function preexec () {
    # Screen window titles as currently running programs
    if [[ "${TERM}" == "screen-256color" ]]; then
        local CMD="${1[(wr)^(*=*|sudo|-*)]}"
        echo -n "\ek$CMD\e\\"
    fi
}

function setprompt () {
    if [[ "${terminfo[colors]}" -ge 8 ]]; then
        colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_"${color}"="%{${terminfo[bold]}$fg[${(L)color}]%}"
	eval PR_LIGHT_"${color}"="%{$fg[${(L)color}]%}"
    done
    PR_NO_COLOUR="%{${terminfo[sgr0]}%}"

    # Try to use extended characters to look nicer
    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{${terminfo[enacs]}%}"
    PR_SHIFT_IN="%{${terminfo[smacs]}%}"
    PR_SHIFT_OUT="%{${terminfo[rmacs]}%}"
    PR_HBAR="${altchar[q]:--}"
    PR_ULCORNER="${altchar[l]:--}"
    PR_LLCORNER="${altchar[m]:--}"
    PR_LRCORNER="${altchar[j]:--}"
    PR_URCORNER="${altchar[k]:--}"

    # Terminal prompt settings
    case "${TERM}" in
        dumb) # Simple prompt for dumb terminals
            unsetopt zle
            PROMPT='%n@%m:%~%% '
            ;;
        linux) # Simple prompt with Zenburn colors for the console
            echo -en "\e]P01e2320" # zenburn black (normal black)
            echo -en "\e]P8709080" # bright-black  (darkgrey)
            echo -en "\e]P1705050" # red           (darkred)
            echo -en "\e]P9dca3a3" # bright-red    (red)
            echo -en "\e]P260b48a" # green         (darkgreen)
            echo -en "\e]PAc3bf9f" # bright-green  (green)
            echo -en "\e]P3dfaf8f" # yellow        (brown)
            echo -en "\e]PBf0dfaf" # bright-yellow (yellow)
            echo -en "\e]P4506070" # blue          (darkblue)
            echo -en "\e]PC94bff3" # bright-blue   (blue)
            echo -en "\e]P5dc8cc3" # purple        (darkmagenta)
            echo -en "\e]PDec93d3" # bright-purple (magenta)
            echo -en "\e]P68cd0d3" # cyan          (darkcyan)
            echo -en "\e]PE93e0e3" # bright-cyan   (cyan)
            echo -en "\e]P7dcdccc" # white         (lightgrey)
            echo -en "\e]PFffffff" # bright-white  (white)
            PROMPT='$PR_GREEN%n@%m$PR_WHITE:$PR_YELLOW%l$PR_WHITE:$PR_RED%~$PR_YELLOW%%$PR_NO_COLOUR '
            ;;
        *)  # Main prompt
            PROMPT='$PR_SET_CHARSET$PR_GREEN$PR_SHIFT_IN$PR_ULCORNER$PR_GREEN$PR_HBAR\
$PR_SHIFT_OUT($PR_GREEN%(!.%SROOT%s.%n)$PR_GREEN@%m$PR_WHITE:$PR_YELLOW%*$PR_GREEN)\
$PR_SHIFT_IN$PR_HBAR$PR_HBAR$PR_HBAR$PR_SHIFT_OUT(\
$PR_RED%$PR_PWDLEN<...<%~%<<$PR_GREEN)$PR_SHIFT_IN$PR_HBAR$PR_HBAR${(e)PR_FILLBAR}$PR_GREEN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE${VIRTUAL_ENV_NAME}$PR_GREEN\
$PR_RED${CONDA_ENV_NAME}$PR_GREEN\
$PR_SHIFT_IN$PR_HBAR$PR_GREEN$PR_URCORNER$PR_SHIFT_OUT\

$PR_GREEN$PR_SHIFT_IN$PR_LLCORNER$PR_GREEN$PR_HBAR$PR_SHIFT_OUT(\
%(?..$PR_RED%?$PR_WHITE:)%(!.$PR_RED.$PR_YELLOW)%#$PR_GREEN)$PR_NO_COLOUR '

            RPROMPT=' $PR_GREEN$PR_SHIFT_IN$PR_HBAR$PR_GREEN$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'
            ;;
    esac
}

# Prompt init
setprompt
# }}}
# }}}


# Set the language to a reasonable default.
export LC_ALL="en_US.UTF-8"


############ Work specific stuff ############
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

#cuda stuff
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-8.0/lib64
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-8.0/extras/CUPTI/lib64
#export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda-8.0/lib64
#export CPATH=$CPATH:/usr/local/cuda-8.0/lib64
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.0/lib64
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.0/extras/CUPTI/lib64
#export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda-11.0/lib64
#export CPATH=$CPATH:/usr/local/cuda-11.0/lib64

#cudnn from home
#export LD_LIBRARY_PATH=~/cudnn/cudnn6.0/lib64:$LD_LIBRARY_PATH
#export CPATH=~/cudnn/cudnn6.0/include:$CPATH
#export LIBRARY_PATH=~/cudnn/cudnn6.0/lib64:$LIBRARY_PATH
#export LD_LIBRARY_PATH=~/cudnn/cudnn7.0/lib64:$LD_LIBRARY_PATH
#export CPATH=~/cudnn/cudnn7.0/include:$CPATH
#export LIBRARY_PATH=~/cudnn/cudnn7.0/lib64:$LIBRARY_PATH


# Ros Hydro
#[ -f /opt/ros/hydro/setup.zsh ] && source /opt/ros/hydro/setup.zsh

# Ros Indigo
#[ -f /opt/ros/indigo/setup.zsh ] && source /opt/ros/indigo/setup.zsh

# Ros Melodic
[ -f /opt/ros/melodic/setup.zsh ] && source /opt/ros/melodic/setup.zsh

# Ros Catkin ws.
#[ -f ~/catkin_ws/devel/setup.zsh ] && source ~/catkin_ws/devel/setup.zsh

# Rovina catkin
#[ -f /data/work/Rovina/new_catkin/devel/setup.zsh ] && source /data/work/Rovina/new_catkin/devel/setup.zsh
#export ROVINA_DEV=/data/work/Rovina/new_catkin/src/rovina-dev

# Strands catkin
#[ -f /data/work/strands/catkin_ws/devel/setup.zsh ] && source /data/work/strands/catkin_ws/devel/setup.zsh


################## Useful stuff :D ########################

#For getting a nice prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1
[ -f ~/anaconda3/bin/conda ] && ~/anaconda3/bin/conda config --set changeps1 False

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward
# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# For jumping over words with control
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word


# Setup conda, but don't always source it to keep starting the shell a bit faster.
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/home/hermans/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/home/hermans/anaconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/hermans/anaconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/hermans/anaconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<
function start_conda {
    [ -d /home/hermans/anaconda3 ] && eval "$(/home/hermans/anaconda3/bin/conda shell.zsh hook)"
}

# Make sure the module load stuff works in on lab machines
[ -f /usr/share/modules/init/zsh ] && source /usr/share/modules/init/zsh

# umask to create files in a safer way than the ubuntu default
umask 0077

# Activate fuzzy finder if available
# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
