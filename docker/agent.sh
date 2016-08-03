#!/bin/sh

# For debug:
#set -x

SERVICE='netchecker-service'
ENDPOINT='8081/api/v1/agents'

while : ; do
  HOST=`hostname`
  DATE=`date +"%Y-%m-%d %H:%M:%S"`
  RESOLV=`cat /etc/resolv.conf`
  NSLOOKUP=`nslookup $SERVICE`
  IPS=`ip -4 a | grep inet`
  PRE_DATA=$(cat <<EOF
{
  "hostname": "$HOST",
  "hostdate": "$DATE",
  "resolvconf": "$RESOLV",
  "nslookup": "$NSLOOKUP",
  "ips": "$IPS"
}
EOF
)
  DATA=`echo $PRE_DATA | tr '\n' ' '`
  curl -i -s --connect-timeout 5 -H 'Content-Type: application/json' -X POST -d "$DATA" http://$SERVICE:$ENDPOINT/$HOST
  sleep 60
done
