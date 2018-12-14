#!/bin/sh
set -e

sed -i "s/CACHE_MEM_SIZE/${CACHE_MEM_SIZE}/"  /etc/nginx/sites-available/generic.conf
sed -i "s/CACHE_MEM_SIZE/${CACHE_MEM_SIZE}/"  /etc/nginx/includes/proxy-cache-paths.conf
sed -i "s/CACHE_DISK_SIZE/${CACHE_DISK_SIZE}/" /etc/nginx/sites-available/generic.conf
sed -i "s/CACHE_DISK_SIZE/${CACHE_DISK_SIZE}/" /etc/nginx/includes/proxy-cache-paths.conf
sed -i "s/CACHE_MAX_AGE/${CACHE_MAX_AGE}/"    /etc/nginx/sites-available/generic.conf
sed -i "s/CACHE_MAX_AGE/${CACHE_MAX_AGE}/"    /etc/nginx/includes/proxy-cache-upstream.conf
sed -i "s/UPSTREAM_DNS/${UPSTREAM_DNS}/"    /etc/nginx/sites-available/generic.conf

cd /etc/nginx/cache-domains
for DOMAIN_FILE in *.txt; do
	echo "server_name" >> /etc/nginx/upstreams/$(echo ${DOMAIN_FILE}|cut -f1 -d. -)-domains.conf;
	cat ${DOMAIN_FILE} >> /etc/nginx/upstreams/$(echo ${DOMAIN_FILE}|cut -f1 -d. -)-domains.conf;
	echo ";" >> /etc/nginx/upstreams/$(echo ${DOMAIN_FILE}|cut -f1 -d. -)-domains.conf;
done

echo "Checking permissions (This may take a long time if the permissions are incorrect on large caches)..."
find /data \! -user ${WEBUSER} -exec chown ${WEBUSER}:${WEBUSER} '{}' +

echo "Done. Starting caching server."

/usr/sbin/nginx -t

./heartbeat.sh ${BEAT_TIME} &

/usr/sbin/nginx -g "daemon off;"
