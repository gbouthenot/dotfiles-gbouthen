#!/bin/bash
FILE=$HOME/.bashrc
SEARCH=call-dotfiles-gbouthen
grep $SEARCH $FILE
if [ $? -eq 0 ] ; then
  echo updating line in $FILE
  sed -i 's/.*call-dotfiles-gbouthen.*/if [ -d \~\/dotfiles-gbouthen ]; then source \~\/dotfiles-gbouthen\/bashrc; fi # call-dotfiles-gbouthen #/' $FILE >/dev/null
else
  echo adding line to $FILE
  echo "if [ -d ~/dotfiles-gbouthen ]; then source ~/dotfiles-gbouthen/bashrc; fi # call-dotfiles-gbouthen #" >>$FILE
fi
