#!/bin/bash

[[ $# -lt 3 ]] && echo "Usage: $0 USERNAME PASSWORD DNS_ID V4/V6(IP version, optional)" && exit 1

COOKIEJAR=/tmp/hover_cookie.txt
USERNAME=${1}
PASSWORD=${2}
DNS_ID=${3}
IP_VERSION=${4:-"V4"}

echo $IP_VERSION
if [ $IP_VERSION == "V6" ]; then
	IP=$(curl "http://v6.ipv6-test.com/api/myip.php" -ks)
else
	IP=$(curl "https://api.ipify.org" -ks)
fi
# echo "IP: ${IP}"

# find your DNS ID here: https://www.hover.com/api/domains/yourdomain.com/dns/

# (replace "yourdomain.com" with your actual domain, and look for the record
# you want to change. The ID looks like: dns1234567)

curl -k "https://www.hover.com/api/login" -X POST -G -d "username=${USERNAME}" -d "password=${PASSWORD}" -s -o /dev/null -c $COOKIEJAR
curl -k "https://www.hover.com/api/dns/${DNS_ID}" -X PUT -d "content=${IP}" -s -b $COOKIEJAR
echo

