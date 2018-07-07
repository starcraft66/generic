FROM nginx:alpine
MAINTAINER Tristan Gosselin-Hane <starcraft66@gmail.com>

ENV GENERICCACHE_VERSION 1
ENV WEBUSER nginx
ENV CACHE_MEM_SIZE 500m
ENV CACHE_DISK_SIZE 500000m
ENV CACHE_MAX_AGE 3560d

COPY overlay/ /

RUN	chmod 755 /scripts/*			;\
	mkdir -m 755 -p /data/cache		;\
	mkdir -m 755 -p /data/info		;\
	mkdir -m 755 -p /data/logs		;\
	mkdir -m 755 -p /tmp/nginx/		;\
	chown -R ${WEBUSER}:${WEBUSER} /data/	;\
	mkdir -p /etc/nginx/sites-enabled	;\
	mkdir -p /etc/nginx/upstreams		;\
	ln -s /etc/nginx/sites-available/blizzard.conf /etc/nginx/sites-enabled/blizzard.conf ;\
	ln -s /etc/nginx/sites-available/generic.conf /etc/nginx/sites-enabled/generic.conf	;\
	ln -s /etc/nginx/sites-available/origin.conf /etc/nginx/sites-enabled/origin.conf	;\
	ln -s /etc/nginx/sites-available/riot.conf /etc/nginx/sites-enabled/riot.conf	;\
	ln -s /etc/nginx/sites-available/steam.conf /etc/nginx/sites-enabled/steam.conf	;\
	ln -s /etc/nginx/sites-available/winupdate.conf /etc/nginx/sites-enabled/winupdate.conf

VOLUME ["/data/logs", "/data/cache", "/var/www"]

EXPOSE 80

WORKDIR /scripts

ENTRYPOINT ["/scripts/bootstrap.sh"]
