# Dockerfile for lighttpd

FROM alpine

ENV LIGHTTPD_VERSION=1.4.54-r0

RUN apk add --update --no-cache \
	lighttpd=${LIGHTTPD_VERSION} \
	lighttpd-mod_auth \
        apache2-utils \
	bash \
  && rm -rf /var/cache/apk/*

## workaround for bug preventing sync between VirtualBox and host
# http://serverfault.com/questions/240038/lighttpd-broken-when-serving-from-virtualbox-shared-folder
RUN echo server.network-backend = \"writev\" >> /etc/lighttpd/lighttpd.conf

#
# add user to get mod_auth working
# 'authorized users only' must match 'realm' value in lighttpd.conf auth.require statement
#  htdigest -c passwd.digest 'authorized users only' ryu
COPY passwd.digest /etc/lighttpd/passwd.digest

COPY etc/lighttpd/* /etc/lighttpd/
COPY start.sh /usr/local/bin/
EXPOSE 80

VOLUME /var/www/localhost
VOLUME /etc/lighttpd

CMD ["start.sh"]
