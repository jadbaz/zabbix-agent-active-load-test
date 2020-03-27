#!/usr/bin/env bash
######################################################
SCRIPT_NAME="$(basename $0)"
SCRIPT_FULL_PATH="$(readlink -f $0)"
DIR="$(dirname ${SCRIPT_FULL_PATH})"
cd "$DIR"
######################################################

USAGE="$0 <num>"

i=$1
re='^[0-9]+$'
if ! [[ $i =~ $re ]] ; then
   echo "USAGE: $USAGE" >&2; exit 1
fi

CONTAINER_NAME_PREFIX=`sed -n -e 's/^DOCKER_CONTAINER_NAME_PREFIX\s*=\s*\(.*\)/\1/p' ./vars`
if [[ -z $CONTAINER_NAME_PREFIX ]]
then
    echo "Please provide a DOCKER_CONTAINER_NAME_PREFIX in the vars file (DOCKER_CONTAINER_NAME_PREFIX=<DOCKER_CONTAINER_NAME_PREFIX>)"
    exit 1
fi

NAME=${CONTAINER_NAME_PREFIX}${i}

if docker inspect -f '{{.State.Running}}' $NAME > /dev/null 2>&1;
then
   CMD="docker stop $NAME"
   echo $CMD
   eval $CMD
   echo
fi

if docker inspect $NAME > /dev/null 2>&1;
then
   CMD="docker rm $NAME"
   echo $CMD
   eval $CMD
   echo
fi

