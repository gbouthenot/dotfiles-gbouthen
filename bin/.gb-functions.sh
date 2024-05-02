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
    a=`base64 -w0 -- "$1"`
    echo " "echo \"$a\" \| base64 -d \> "$1"
  else
    a=`bzip2 --best -c -- "$1" | base64 -w0`
    echo " "echo \"$a\" \| base64 -d \| bunzip2 \> \"$1\"
  fi
}
function gbsha384() {
  while [ $1 ]; do echo -n $1: integrity=\"sha384- ; openssl dgst -sha384 -binary $1 | openssl base64 -A ; echo \" ; shift ; done
}

function gbprompt-std() {
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
# tport: test tcp and udp port.
# does only work with BASH !
# Examples:
# udp: tport 0.pool.ntp.org 123 udp
# tcp with 0.5s timeout: tport ldap.example.org 389 .5
###
function tport() {
  [ -z "$1" -o -z "$2" ] && >&2 echo "Usage: tport host port [tcp|udp] [timeout=1]" && return 9
  i="$1" ; po="$2"
  # re='^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' ; [[ ! "$i" =~ $re ]] && >&2 echo "$i is not an ipv4 address" && return 9
  re='^[0-9]+$' ; [[ ! "$po" =~ $re ]] && >&2 echo "$po is not a port number" && return 9
  pr=tcp ; [ "$3" == udp -o "$3" == tcp ] && pr="$3" && shift
  t=1 ; re='^[0-9]*(\.[0-9]+)?$' ; [[ -n "$3" && "$3" =~ $re ]] && t="$3"
  timeout $t bash -c '< /dev/$1/$2/$3 && echo open || (echo closed)' arg0 $pr $i $po 2>/dev/null || echo timeout
}

function gbgitauthor-ac {
  local dom="ac-besancon"
  export GIT_AUTHOR_NAME="Gilles Bouthenot"
  export GIT_AUTHOR_EMAIL="gilles.bouthenot@$dom.fr"
}

function gbyank {
  # get data either form stdin or from file
  local buf=$(cat "$@")

  # build up OSC 52 ANSI escape sequence
  local esc="\033]52;c;$( printf %s "$buf" | base64 | tr -d '\r\n' )\a"
  printf $esc
}

function docohc { for cid in $(docker-compose ps -q) ; do docker inspect $cid | jq ".[] | { Name, Health: .State.Health }" ; done }
function docops { if [ -x /usr/libexec/docker/cli-plugins/docker-compose ]; then docker compose ps --format 'table {{.Name}}\t{{.Status}}\t{{.Ports}}'; else docker-compose ps; fi }
function ldapdecode { perl -MMIME::Base64 -n -00 -e 's/\n //g;s/(?<=:: )(\S+)/decode_base64($1)/eg;print'; }
function me() { [ -x /usr/bin/mcedit ] && /usr/bin/mcedit "$@" ; }

function gbmping {
  (for f in $@ ; do ping $f & done; wait)
}
