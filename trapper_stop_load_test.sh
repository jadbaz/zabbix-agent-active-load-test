#!/usr/bin/env bash
######################################################
SCRIPT_NAME="$(basename $0)"
SCRIPT_FULL_PATH="$(readlink -f $0)"
DIR="$(dirname ${SCRIPT_FULL_PATH})"
cd "$DIR"
######################################################

USAGE="$0 <start> <end> <increment>"

start=1
end=1

if [ -n "$1" ] && [ "$1" -eq "$1" ] 2>/dev/null; then
  start=$1
else
  echo "USAGE: $USAGE"; exit 1
fi

if [ -n "$2" ] && [ "$2" -eq "$2" ] 2>/dev/null; then
  end=$2
else
  echo "USAGE: $USAGE"; exit 1
fi

if [ -n "$3" ] && [ "$3" -eq "$3" ] 2>/dev/null; then
  inc=$3
else
  echo "USAGE: $USAGE"; exit 1
fi


i=$start
while [[ $i -lt $end ]];
do
  s=$i
  e=$(($i+$inc-1))
  
  if [[ $e -ge $end ]];
  then
    e=$end
  fi

  i=$(($e+1))
  
  CMD="sh $DIR/trapper_stop_instance.sh $s"
  echo $CMD
  eval $CMD
done


