#IMAGE: waterjuice/h5ai

# Use a different layer to do extraction
FROM ubuntu:14.04 as extract
RUN set -ex ;\
 apt-get update ;\
 apt-get install -y unzip

COPY h5ai-0.29.2.zip .
RUN unzip h5ai-0.29.2.zip -d /usr/share/h5ai

COPY class-setup.php.patch /usr/share/h5ai

# Now build final
FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
ENV HTTPD_USER www-data

RUN set -ex ;\
  apt-get update ;\
  apt-get install -y \
   nginx \
   php5-fpm \
   supervisor \
   wget \
   patch \
   acl \
   libav-tools \
   imagemagick \
   graphicsmagick \
   php5-gd ;\
  rm -rf /var/lib/apt/lists/*

COPY --from=extract /usr/share/h5ai /usr/share/h5ai
ADD h5ai.nginx.conf /etc/nginx/sites-available/h5ai
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# patch h5ai because we want to deploy it ouside of the document root and use /var/www as root for browsing
#COPY class-setup.php.patch class-setup.php.patch
RUN set -ex ;\
 patch -p1 -u -d /usr/share/h5ai/_h5ai/private/php/core/ -i /usr/share/h5ai/class-setup.php.patch ;\
 rm /usr/share/h5ai/class-setup.php.patch ;\
# add default configuration for nginx
 rm /etc/nginx/sites-enabled/default ;\
 ln -s /etc/nginx/sites-available/h5ai /etc/nginx/sites-enabled/h5ai ;\
# make the cache writable
 chown ${HTTPD_USER} /usr/share/h5ai/_h5ai/public/cache/ ;\
 chown ${HTTPD_USER} /usr/share/h5ai/_h5ai/private/cache/ 
 
# use supervisor to monitor all services
CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf

## expose only nginx HTTP port
#EXPOSE 80 443
#
## expose path
#VOLUME /var/www

