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

##############################################

IMAGE=`sed -n -e 's/^ZABBIX_AGENT_DOCKER_IMAGE\s*=\s*\(.*\)/\1/p' ./vars`
if [[ -z $IMAGE ]]
then
   echo "Please provide a ZABBIX_AGENT_DOCKER_IMAGE in the vars file (ZABBIX_AGENT_DOCKER_IMAGE=<ZABBIX_AGENT_DOCKER_IMAGE>)"
   exit 1
fi

CONTAINER_NAME_PREFIX=`sed -n -e 's/^DOCKER_CONTAINER_NAME_PREFIX\s*=\s*\(.*\)/\1/p' ./vars`
if [[ -z $CONTAINER_NAME_PREFIX ]]
then
   echo "Please provide a DOCKER_CONTAINER_NAME_PREFIX in the vars file (DOCKER_CONTAINER_NAME_PREFIX=<DOCKER_CONTAINER_NAME_PREFIX>)"
   exit 1
fi

HOST_NAME_PREFIX=`sed -n -e 's/^AGENT_HOST_NAME_PREFIX\s*=\s*\(.*\)/\1/p' ./vars`
if [[ -z $HOST_NAME_PREFIX ]]
then
   echo "Please provide an AGENT_HOST_NAME_PREFIX in the vars file (AGENT_HOST_NAME_PREFIX=<AGENT_HOST_NAME_PREFIX>)"
   exit 1
fi

IP=`sed -n -e 's/^IP\s*=\s*\(.*\)/\1/p' ./.env`
if [[ -z $IP ]]
then
   echo "Please provide an IP in the .env file (IP=<IP>)"
   exit 1
fi

##############################################

NAME=${CONTAINER_NAME_PREFIX}${i}
HOSTNAME=${HOST_NAME_PREFIX}${i}
SERVER=${IP}

##############################################

echo -e "###################\n$i\n###################"

sh $DIR/stop_instance.sh $i

CMD="docker run -d --name $NAME -e ZBX_SERVER_HOST=$SERVER -e ZBX_HOSTNAME=$HOSTNAME $IMAGE"
echo $CMD
eval $CMD

echo -e "\n"
