function gbsrcipaddr() {
  _a=`echo $SSH_CONNECTION|cut -d " " -f 1`
  echo $_a
}
function gbdstipaddr() {
  _a=`echo $SSH_CONNECTION|cut -d " " -f 3`
  echo $_a
}
function sz64() {
  if [[ $1 == *.bz2 ]] ; then
    a=`base64 -w0 -- $1`
    echo " "echo \"$a\" \| base64 -d \> $1
  else
    a=`bzip2 --best -c -- $1 | base64 -w0`
    echo " "echo \"$a\" \| base64 -d \| bunzip2 \> $1
  fi
}
function gbsha384() {
  while [ $1 ]; do echo -n $1: integrity=\"sha384- ; openssl dgst -sha384 -binary $1 | openssl base64 -A ; echo \" ; shift ; done
}

function gbprompt() {
  PS1="\[\e]0;\u@\h\a\]\[\e[36m\]\t \[\e[32m\]\u(`gbsrcipaddr`)\[\e[0m\]@\[\e[33m\]\h(`gbdstipaddr`)\[\e[0m\]\n\[\e[33m\]\w\[\e[0m\]\$ "
}

function gbprompt-gitradar () {
  # source: https://github.com/michaeldfallen/git-radar
  # Latest commit 2ac25e3 on 5 Dec 2016
  PS1="\[\e]0;\u@\h\a\]\[\e[36m\]\t \[\e[32m\]\u(`gbsrcipaddr`)\[\e[0m\]@\[\e[33m\]\h(`gbdstipaddr`)\[\e[0m\]\$($DOTDIR/git-radar/git-radar --bash --fetch)\n\[\e[33m\]\w\[\e[0m\]\$ "
}

###
# gbagent: start ssh-agent and add private key
# usage: gbagent [private_key_file]
# by default take ~/.ssh/id_rsa
# return if the file does not exist
# if a previous ssh-agent is not found, fork a new one
# add the key to the agent
###
function gbagent() {
  KEY=~/.ssh/id_rsa && [[ -n $1 ]] && KEY=$1
  [[ ! -e $KEY ]] && echo $KEY not found && return
  [[ -z $SSH_AGENT_PID ]] && eval `ssh-agent`
  ssh-add $KEY
}

###
# gbdf
###
function gbdf() {
  df -hT $* | grep -Ev -e "^(cgmfs|overlay|shm|(dev)?tmpfs|udev)" -e "/devicemapper/mnt/"
}

###
# tprt: test tcp and udp port.
# does only work with BASH !
# Samples:
# tprt udp 0.pool.ntp.org 123
# tprt tcp ldap.example.org 389 .5 (.5 second timeout)
###
function tprt() {
  [ "$1" != tcp -a "$1" != udp -o -z "$2" -o -z "$3" ] && >&2 echo "Usage: tprt tcp|udp host port [timeout=1]" && return 9
  timeout ${4:-1} bash -c '</dev/$1/$2/$3 && echo open || (echo closed)' arg0 $* 2>/dev/null || echo timeout
}
