#!/bin/bash

re='^[0-9]+$'
signal=15 #SIGTERM
if [[ $1 =~ $re ]] ; then
  signal=$1
elif [ $1 ]; then
  echo "Not a number: $1" 
  echo "Pass a number as the first argument to use it as a kill signal. Defaults to 15 (SIGTERM)."
  exit
fi

ps="$(ps -U $USER -u $USER -eo comm,pid,pcpu,args  --sort -pcpu  --no-headers)"

# in: a newline-separated list
# out: the selected line, e.g.
# `fzkill           334411  0.0 /bin/bash /home/user/.local/bin/fzkill`
dmenu_cmd="fuzzel -I -w 120 -l 10 -b 3b4252ef -t d8dee9ff -s 88c0d0ff -S 3b4252ff -C 4c566aef -m bf616aff -r 0 --line-height=24px -d --log-no-syslog \"kill -$signal: \""

process="$(echo "$ps" | eval "$dmenu_cmd")"
process_=($process)
pid=${process_[1]}

# quiet exit if pid is empty, loud if PID is invalid
if [ -z "${pid}" ]; then
  exit
elif ! $(kill -s 0 "$pid" &>/dev/null); then
  echo "Error: process with PID '$pid' does not exist."
  exit
fi

exec kill -"$signal" "$pid" 
