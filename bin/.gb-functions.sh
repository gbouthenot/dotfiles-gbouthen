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
