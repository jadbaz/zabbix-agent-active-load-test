#!/usr/bin/env bash
######################################################
SCRIPT_NAME="$(basename $0)"
SCRIPT_FULL_PATH="$(readlink -f $0)"
DIR="$(dirname ${SCRIPT_FULL_PATH})"
cd "$DIR"
######################################################

USAGE="$0 <total_agents>"

N=$1
re='^[0-9]+$'
if ! [[ $N =~ $re ]] ; then
   echo "USAGE: $USAGE" >&2; exit 1
fi

for i in `seq 1 $N`
do
   sh $DIR/run_instance.sh $i
done

