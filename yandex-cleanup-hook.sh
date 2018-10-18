#!/bin/bash
#03.09.2018

_dir="$(dirname "$0")"
source "$_dir/config.sh"

if [ -f /tmp/CERTBOT_${CERTBOT_DOMAIN}/${CERTBOT_VALIDATION} ]; then
        RECORD_ID=$(cat /tmp/CERTBOT_${CERTBOT_DOMAIN}/${CERTBOT_VALIDATION})
        rm -f /tmp/CERTBOT_${CERTBOT_DOMAIN}/${CERTBOT_VALIDATION}
fi

#DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
DOMAIN=$(echo "$CERTBOT_DOMAIN" | awk -F'.' '{print $(NF-1)"."$NF}')
if [ -z "${DOMAIN}" ]; then
        echo "CERTBOT_DOMAIN=${CERTBOT_DOMAIN}, DOMAIN=${DOMAIN}, BAD DOMAIN, exit"
        exit
fi

API_KEY=${PDDTOKENMAP["$DOMAIN"]}
if [ -z "${API_KEY}" ]; then
        echo "No API_KEY for DOMAIN=${DOMAIN}, exit"
        exit
fi

# Remove the challenge TXT record from the zone
if [ -n "${RECORD_ID}" ]; then
        RESULT=$(curl -s -X POST "https://pddimp.yandex.ru/api2/admin/dns/del" \
     -H "PddToken: $API_KEY" \
     -d "domain=$DOMAIN&record_id=$RECORD_ID" \
         | python -c "import sys,json;print(json.load(sys.stdin)['success'])")

        echo $RESULT 
fi
