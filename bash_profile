# from http://superuser.com/questions/183870/difference-between-bashrc-and-bash-profile
if [ -r ~/.profile ]; then . ~/.profile; fi
case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac
