# certbot-dns-pddyandex
PDD Yandex DNS API for certbot --manual-auth-hook --manual-cleanup-hook
Можно делать 2-3 различных домена в одном сертификате (больше 3 WildCard не пробовал)
Можно делать сертификаты WildCard 5-го уровня: aa.bb.cc.site.com

Install and renew Let's encrypt wildcard ssl certificate for domain *.site.com using PDD Yandex DNS API:

#### 1) Clone this repo and set the API key
```bash
git clone https://github.com/actionm/certbot-dns-pddyandex/ && cd ./certbot-dns-pddyandex
```

#### 2) Set API KEY

Get your PDD Yandex API key from https://tech.yandex.ru/pdd/doc/concepts/access-docpage/ )
Получение/замена token: https://pddimp.yandex.ru/api2/admin/get_token

```bash
nano ./config.sh
```

#### 3) Install CertBot from git
```bash
cd ../ && git clone https://github.com/certbot/certbot && cd certbot
```

#### 4) Generate wildcard
```bash
./letsencrypt-auto certonly --manual-public-ip-logging-ok --agree-tos --email info@site.com --renew-by-default -d site.com -d *.site.com --manual --manual-auth-hook ../certbot-dns-pddyandex/yandex-auth-hook.sh --manual-cleanup-hook ../certbot-dns-pddyandex/yandex-cleanup-hook.sh --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory
```

#### 5) Force Renew
```bash
./letsencrypt-auto renew --force-renew --manual --manual-auth-hook ../certbot-dns-pddyandex/yandex-auth-hook.sh --manual-cleanup-hook ../certbot-dns-pddyandex/yandex-cleanup-hook.sh --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory
```
