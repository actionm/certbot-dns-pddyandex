# Get your API key from https://tech.yandex.ru/pdd/doc/concepts/access-docpage
# Get token for domain from https://tech.yandex.ru/pdd/doc/concepts/access-docpage/

declare -A PDDTOKENMAP
PDDTOKENMAP["domain1.tld"]='52 symbols of key ....'
PDDTOKENMAP["domain2.tld"]='52 symbols of key....'

# yandex min ttl = 90 sec
declare -A TTLMAP
TTLMAP["domain1.tld"]=90
TTLMAP["domain2.tld"]=90

# pause after auth hook
declare -A SLEEPMAP
SLEEPMAP["domain1.tld"]=5
SLEEPMAP["domain2.tld"]=5
