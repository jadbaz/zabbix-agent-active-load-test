SERVER_IP=$1
SERVER_PORT=$2
PREFIX=$3
KEY=$4
VALUE=$5
START=$6
END=$7

echo "STARTING TRAPPER LOAD TEST"
echo

echo "SERVER_IP=$SERVER_IP"
echo "SERVER_PORT=$SERVER_PORT"
echo "PREFIX=$PREFIX"
echo "KEY=$KEY"
echo "VALUE=$VALUE"
echo "START=$START"
echo "END=$END"

x=0
while true
do
    x=$((x+1))
    echo "### STARTING ITERATION $x ###"
    for i in `seq $START $END`
    do
        echo -n "$i "
        zabbix_sender -z $SERVER_IP -p $SERVER_PORT -s ${PREFIX}${i} -k $KEY -o $VALUE
    done
    echo
    echo
    sleep 1
done
