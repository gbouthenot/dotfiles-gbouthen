###- BEGIN gilles debianrc
### v1.00
### v1.01: add ldapdecode
### v1.02: node auto install if /opt/node is present
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

export LS_OPTIONS='--color=auto'
export EDITOR=/usr/bin/mcedit
export LANG=en_US.UTF8
eval "`dircolors`"
#PS1='${debian_chroot:+($debian_chroot)}\u@\h \t \w\$ '
#PS1="\[\e]0;\u@\h\a\]\[\e[36m\]\t \[\e[32m\]\u@\h `gbsrcipaddr`\n\[\e[33m\]\w\[\e[0m\]\$ "
PS1='\[\e]0;\u@\h\a\]\[\e[36m\]\t \[\e[32m\]\u(`gbsrcipaddr`)\[\e[0m\]@\[\e[33m\]\h(`gbdstipaddr`)\[\e[0m\]\n\[\e[33m\]\w\[\e[0m\]\$ '

alias dir='ls --color=auto --format=long -al'
alias ls='ls --color=auto '
alias hdir='ls --color=auto --format=vertical'
alias ldapdecode="perl -MMIME::Base64 -n -00 -e 's/\n //g;s/(?<=:: )(\S+)/decode_base64(\$1)/eg;print'"
shopt -s checkwinsize
umask 002

# --- NodeJS
if [ -d /opt/node -o -h /opt/node ]; then
  export PATH=$PATH:/opt/node/bin:$HOME/node_modules/.bin
  export NODE_PATH=/opt/node:/opt/node/lib/node_modules:$HOME/node_modules
fi
# ---

#function subl() { /opt/Subl2/sublime_text "$@" & }

# disable ^S / ^Q
stty stop undef
stty start undef
###- END gilles debianrc
