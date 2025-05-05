These files are located on the demo server to manage auto reinstallaton and SSL update

```cd /var/docker/```

Cron job for auto update:
```
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

*/30 * * * * cd /var/docker/ && docker-compose pull && docker-compose  up --build --force-recreate -d >> /var/log/demo_build.log 2>&1

0 0 1 */2 * cd /var/docker/ && bash /var/docker/init-letsencrypt.sh
```