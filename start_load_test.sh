#!/usr/bin/env bash
######################################################
SCRIPT_NAME="$(basename $0)"
SCRIPT_FULL_PATH="$(readlink -f $0)"
DIR="$(dirname ${SCRIPT_FULL_PATH})"
cd "$DIR"
######################################################

USAGE="$0 <start> <end>"

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

for i in `seq $start $end`
do
   sh $DIR/start_instance.sh $i
done

