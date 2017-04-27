### v1.00
### v1.01: add ldapdecode
### v1.02: node auto install if /opt/node is present
### v1.03: tmux19-deb7 https://packages.debian.org/wheezy-backports/amd64/tmux/download tmux_1.9-6~bpo70+1_amd64


# --- Function definition
function gbsrcipaddr() {
  _a=`echo $SSH_CONNECTION|cut -d " " -f 1`
  echo $_a
}
function gbdstipaddr() {
  _a=`echo $SSH_CONNECTION|cut -d " " -f 3`
  echo $_a
}
function sz64() {
  _a=`bzip2 -c $1 | base64 -w0`
  echo echo \"$_a\" \| base64 -d \| bunzip2 \> $1
}
#function subl() { /opt/Subl2/sublime_text "$@" & }
# ---

# Location of the dotfiles dir
DOTDIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) && cd .. && pwd )

# --- Environment
export LS_OPTIONS='--color=auto'
export LANG=en_US.UTF8
unset LC_ALL
[[ "$PATH" == */${DOTDIR}/bin* ]] || export PATH=$PATH:~/bin:${DOTDIR}/bin
# ---


# --- Aliases
alias dir='ls --color=auto --format=long -al'
alias ls='ls --color=auto '
alias hdir='ls --color=auto --format=vertical'
alias ldapdecode="perl -MMIME::Base64 -n -00 -e 's/\n //g;s/(?<=:: )(\S+)/decode_base64(\$1)/eg;print'"
# ---


# --- Midnight commander
if [ -f /usr/bin/mcedit ]; then
  export EDITOR="/usr/bin/mcedit -d"
fi
if [ "$TERM" = "screen" ]; then
  # disable mouse for mc / mcedit
  if [ -f /usr/bin/mcedit ]; then
    export EDITOR="/usr/bin/mcedit -d"
    alias mcedit="/usr/bin/mcedit -d"
  fi
  if [ -f /usr/bin/mc ]; then
    alias mc="/usr/bin/mc -d "
  fi
fi
# ---


# --- NodeJS
if [ -d /opt/node -o -h /opt/node ]; then
  [[ "$PATH" == */opt/node/bin* ]] || export PATH=$PATH:/opt/node/bin:$HOME/node_modules/.bin
  export NODE_PATH=/opt/node:/opt/node/lib/node_modules:$HOME/node_modules
fi
# ---



# --- TMUX
PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
if [ -e /lib/terminfo/s/screen-256color ]; then
  alias tmux="TERM=screen-256color tmux -f ${DOTDIR}/.tmux.conf" # problème avec les red hat
  if [ -e /usr/bin/lsb_release ]; then
    if [ -e ${DOTDIR}/bin/tmux-`lsb_release -cs`-`uname -m` ]; then
      alias tmux="TERM=screen-256color ${DOTDIR}/bin/tmux-`lsb_release -cs`-`uname -m` -f ${DOTDIR}/.tmux.conf"
    fi
  fi
else
  alias tmux="TERM=xterm-256color tmux -f ${DOTDIR}/.tmux.conf"
fi

# add a function to freshen the tmux environment
# http://stackoverflow.com/questions/18241406/tmux-environment-variables-dont-show-up-in-session
if [ -n "$TMUX" ]; then
  tmup () {
    echo -n "Updating to latest tmux environment...";
    export IFS=",";
    for line in $(tmux showenv -t $(tmux display -p "#S") | tr "\n" ",");
    do
      if [[ $line == -* ]]; then
        unset $(echo $line | cut -c2-);
      else
        export $line;
      fi;
    done;
    unset IFS;
    echo "Done"
  }
fi
# ---

# Don't execute further if not used interactly source: http://superuser.com/questions/789448/choosing-between-bashrc-profile-bash-profile-etc
# http://superuser.com/questions/789448/choosing-between-bashrc-profile-bash-profile-etc
[[ $- == *i* ]] || return 0


# --- Copy files
# copy all files from "copy"
#cp -aurv $DOTDIR/copy/{*,.[^.]*,..?*} ~
cp -aurv $DOTDIR/copy/.[^.]* ~
# ---


# --- Misc
# disable ^S / ^Q
stty stop undef 2>/dev/null
stty start undef 2>/dev/null

# Allow the use of exclamation mark
set +o histexpand

shopt -s checkwinsize
umask 002

eval "`dircolors`"
PS1='\[\e]0;\u@\h\a\]\[\e[36m\]\t \[\e[32m\]\u(`gbsrcipaddr`)\[\e[0m\]@\[\e[33m\]\h(`gbdstipaddr`)\[\e[0m\]\n\[\e[33m\]\w\[\e[0m\]\$ '
# ---

unset DOTDIR
