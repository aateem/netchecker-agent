#!/bin/sh

# For debug:
#set -x

report_interval=${REPORT_INTERVAL:-60}
SERVICE='netchecker-service'
ENDPOINT='8081/api/v1/agents'

while : ; do
  HOST=$(hostname)
  DATE=$(date +"%Y-%m-%d %H:%M:%S")
  RESOLV=$(cat /etc/resolv.conf)
  NSLOOKUP=$(nslookup $SERVICE)
  IPS=$(ip -4 a | grep inet)
  PRE_DATA=$(cat <<EOF
{
  "podname": "$MY_POD_NAME",
  "hostname": "$HOST",
  "hostdate": "$DATE",
  "resolvconf": "$RESOLV",
  "nslookup": "$NSLOOKUP",
  "ips": "$IPS",
  "report_interval": "$report_interval"
}
EOF
)
  DATA=$(echo "$PRE_DATA" | tr '\n' ' ')
  curl -i -s --connect-timeout 5 -H 'Content-Type: application/json' -X POST -d "$DATA" "http://$SERVICE:$ENDPOINT/$MY_POD_NAME"
  sleep "$report_interval"
done
