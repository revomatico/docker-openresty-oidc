FROM openresty/openresty:xenial
MAINTAINER Cristian Chiru <cristian.chiru@dcsi.eu>

EXPOSE 8888

COPY lua-resty-openidc/openidc.lua /usr/local/openresty/lualib/resty/
