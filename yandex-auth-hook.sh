#!/bin/bash

_dir="$(dirname "$0")"
source "$_dir/config.sh"

# Strip only the top domain to get the zone id
#DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
DOMAIN=$(echo "$CERTBOT_DOMAIN" | awk -F'.' '{print $(NF-1)"."$NF}')
if [ -z "${DOMAIN}" ]; then
        echo "CERTBOT_DOMAIN=${CERTBOT_DOMAIN}, DOMAIN=${DOMAIN}, exit"
        exit
fi

API_KEY=${PDDTOKENMAP["$DOMAIN"]}
if [ -z "${API_KEY}" ]; then
        echo "No API_KEY for DOMAIN=${DOMAIN}, exit"
        exit
fi

DOMAINTTL=${TTLMAP["$DOMAIN"]}
if [ -z "${DOMAINTTL}" ]; then
        echo "No TTL for DOMAIN=${DOMAIN}, exit"
        exit
fi

DOMAINSLEEP=${SLEEPMAP["$DOMAIN"]}
if [ -z "${DOMAINSLEEP}" ]; then
        echo "No SLEEP for DOMAIN=${DOMAIN}, exit"
        exit
fi

# Create TXT record
RECORD_ID=$(curl -s -X POST "https://pddimp.yandex.ru/api2/admin/dns/add" \
     -H "PddToken: $API_KEY" \
     -d "domain=${DOMAIN}&type=TXT&content=${CERTBOT_VALIDATION}&ttl=${DOMAINTTL}&subdomain=_acme-challenge.${CERTBOT_DOMAIN}" \
         | python -c "import sys,json;print(json.load(sys.stdin)['record']['record_id'])")

# Save info for cleanup
if [ ! -d /tmp/CERTBOT_$CERTBOT_DOMAIN ];then
        mkdir -m 0700 /tmp/CERTBOT_$CERTBOT_DOMAIN
fi

echo $RECORD_ID > /tmp/CERTBOT_${CERTBOT_DOMAIN}/${CERTBOT_VALIDATION}

# Sleep to make sure the change has time to propagate over to DNS
sleep ${DOMAINSLEEP}
