#!/bin/bash

random_string=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)

outfile="/tmp/plog.$random_string.log"

logfile="/var/log/nginx/error.log"


mkfifo $outfile

tail -fn80 $logfile > $outfile &

tail_pid=$!


function cleanup() {
  kill $tail_pid
  rm $outfile
  exit
}


function add_blank_lines() {
  if [[ $1 =~ ^[0-9]{4}/[0-9]{2}/[0-9]{2} ]]; then
    echo
    echo
  fi
}

function highlight_error() {
  line=$(echo "$1" | sed -E 's/(PHP (Parse|Fatal)? error:)/'"\n$(tput setaf 1)"'\1'"$(tput sgr0)"'/g')
}

function highlight_warning() {
  line=$(echo "$1" | sed -E 's/(PHP Warning:)/'"\n$(tput setaf 3)"'\1'"$(tput sgr0)"'/g')
}

function highlight_notice() {
  line=$(echo "$1" | sed -E 's/(PHP Notice:)/'"\n$(tput setaf 4)"'\1'"$(tput sgr0)"'/g')
}

function highlight_deprecated() {
  line=$(echo "$1" | sed -E 's/(PHP Deprecated:)/'"\n$(tput setaf 7)"'\1'"$(tput sgr0)"'/g')
}

function highlight_trace() {
  line=$(echo "$1" | sed -E 's/(Stack trace:)/'"$(tput setaf 6)"'\1'"$(tput sgr0)"'/g')
}

function break_line() {
  line=$(echo "$1" | sed -E 's/( while reading response header from upstream, )/'"\n"'/g')
}

function break_upstream() {
  line=$(echo "$1" | sed -E 's/(, upstream:)/'"\nupstream:"'/g')
}

function hide_php_message() {
  line=$(echo "$1" | sed -E 's/(PHP message:)/'"\ | "'/g')
}

trap cleanup INT

while IFS= read -r line
do

  add_blank_lines "$line"

  hide_php_message "$line"

  break_line "$line"

  break_upstream "$line"

  highlight_error "$line"

  highlight_warning "$line"

  highlight_notice "$line"

  highlight_deprecated "$line"

  highlight_trace "$line"

  echo "$(tput setaf 2)▶$(tput sgr0) $line"

done < $outfile