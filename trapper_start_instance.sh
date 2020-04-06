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

##############################################

IMAGE=`sed -n -e 's/^ZABBIX_AGENT_DOCKER_IMAGE\s*=\s*\(.*\)/\1/p' ./vars`
if [[ -z $IMAGE ]]
then
   echo "Please provide a ZABBIX_AGENT_DOCKER_IMAGE in the vars file (ZABBIX_AGENT_DOCKER_IMAGE=<ZABBIX_AGENT_DOCKER_IMAGE>)"
   exit 1
fi

CONTAINER_TRAPPER_NAME_PREFIX=`sed -n -e 's/^DOCKER_CONTAINER_TRAPPER_NAME_PREFIX\s*=\s*\(.*\)/\1/p' ./vars`
if [[ -z $CONTAINER_TRAPPER_NAME_PREFIX ]]
then
   echo "Please provide a DOCKER_CONTAINER_TRAPPER_NAME_PREFIX in the vars file (DOCKER_CONTAINER_TRAPPER_NAME_PREFIX=<DOCKER_CONTAINER_TRAPPER_NAME_PREFIX>)"
   exit 1
fi

TRAPPER_KEY=`sed -n -e 's/^TRAPPER_KEY\s*=\s*\(.*\)/\1/p' ./vars`
if [[ -z $TRAPPER_KEY ]]
then
   echo "Please provide a TRAPPER_KEY in the vars file (TRAPPER_KEY=<TRAPPER_KEY>)"
   exit 1
fi

TRAPPER_VALUE=`sed -n -e 's/^TRAPPER_VALUE\s*=\s*\(.*\)/\1/p' ./vars`
if [[ -z $TRAPPER_VALUE ]]
then
   echo "Please provide a TRAPPER_VALUE in the vars file (TRAPPER_VALUE=<TRAPPER_VALUE>)"
   exit 1
fi

HOST_NAME_PREFIX=`sed -n -e 's/^TRAPPER_HOST_NAME_PREFIX\s*=\s*\(.*\)/\1/p' ./vars`
if [[ -z $HOST_NAME_PREFIX ]]
then
   echo "Please provide an TRAPPER_HOST_NAME_PREFIX in the vars file (TRAPPER_HOST_NAME_PREFIX=<TRAPPER_HOST_NAME_PREFIX>)"
   exit 1
fi

IP=`sed -n -e 's/^IP\s*=\s*\(.*\)/\1/p' ./.env`
if [[ -z $IP ]]
then
   echo "Please provide an IP in the .env file (IP=<IP>)"
   exit 1
fi

##############################################

NAME=${CONTAINER_TRAPPER_NAME_PREFIX}${start}
SERVER=${IP}

##############################################

echo -e "###################\n$i\n###################"

sh $DIR/trapper_stop_instance.sh $start

CMD="docker run --rm -d --name $NAME -v `pwd`/trapper_load_test.sh:/var/lib/zabbix/modules/trapper_load_test.sh $IMAGE sh /var/lib/zabbix/modules/trapper_load_test.sh $IP 10051 $CONTAINER_TRAPPER_NAME_PREFIX $TRAPPER_KEY $TRAPPER_VALUE $start $end"

echo $CMD
eval $CMD

echo -e "\n"
