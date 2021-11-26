### v1.00
### v1.01: add ldapdecode
### v1.02: node auto install if /opt/node is present
### v1.03: tmux19-deb7 https://packages.debian.org/wheezy-backports/amd64/tmux/download tmux_1.9-6~bpo70+1_amd64


# Location of the dotfiles dir
DOTDIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) && cd .. && pwd )

# --- Environment
export HISTCONTROL=ignoreboth
export LANG=en_US.UTF8
export LS_OPTIONS='--color=auto'
unset LC_ALL
unset SSH_ASKPASS
[[ "$PATH" == */${DOTDIR}/bin* ]] || export PATH="$PATH:~/bin:${DOTDIR}/bin:~/.local/bin"
# ---


# --- Aliases
alias dir='ls --color=auto --format=long -al'
alias ls='ls --color=auto '
alias ll='ls -al --color=auto '
alias hdir='ls --color=auto --format=vertical'
alias ldapdecode="perl -MMIME::Base64 -n -00 -e 's/\n //g;s/(?<=:: )(\S+)/decode_base64(\$1)/eg;print'"
unalias cp mv rm 2>/dev/null
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

# if a binary is provided, use it
if [ -e ${DOTDIR}/bin/tmux-`lsb_release -cs`-`uname -m` ]; then
  alias tmux="${DOTDIR}/bin/tmux-`lsb_release -cs`-`uname -m`"
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
# change -u (update by newer) to -n (no overwrite) ?
#cp -aurv $DOTDIR/copy/{*,.[^.]*,..?*} ~
cp -aurv $DOTDIR/copy/.[^.]* ~

# set MC skin in ~/.config/mc/ini
MC_SKIN=~/.local/share/mc/default_bold.ini
sed -i 's/^skin=.*/skin=\/root\/.local\/share\/mc\/default_bold.ini/' ~/.config/mc/ini >/dev/null

# set tmux internal terminal
interm="screen"
[ -e /usr/lib/terminfo/t/screen-256color ] && interm="screen-256color"
[ -e /usr/lib/terminfo/t/tmux-256color ] && interm="tmux-256color"
sed -i "s/^set -g default-terminal .*/set -g default-terminal "$interm"/" ~/.tmux.conf


# ---


# --- ~/.bash_profile
# Create file if it does not exist, append nonpresent lines
#
INFILE=$DOTDIR/bash_profile
OUTFILE=~/.bash_profile
[ ! -e "$OUTFILE" ] && >"$OUTFILE"
while IFS='' read -r line || [[ -n "$line" ]]; do
  grep -Fq "$line" "$OUTFILE" || ( echo "Appending line to $OUTFILE: $line" ; echo "$line" >>"$OUTFILE" )
done < "$INFILE"


# --- Git
#
if which git >/dev/null 2>&1 ; then
  git config --global push.default simple "!^$"
  git config --global gc.autodetach false "!^$"
  git config --global color.ui auto "!^$"
  git config --global alias.br branch "!^$"
  git config --global alias.st status "!^$"
fi
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

source $DOTDIR/bin/.gb-functions.sh
gbprompt-std
# ---

# unset DOTDIR
