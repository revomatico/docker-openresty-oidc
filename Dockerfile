FROM alpine
MAINTAINER Cristian Chiru <cristian.chiru@dcsi.eu>

ENV LUA_SUFFIX=jit-2.1.0-beta3 \
    LUAJIT_VERSION=2.1 \
    NGINX_PREFIX=/opt/openresty/nginx \
    OPENRESTY_PREFIX=/opt/openresty \
    OPENRESTY_SRC_SHA256=946e1958273032db43833982e2cec0766154a9b5cb8e67868944113208ff2942 \
    OPENRESTY_VERSION=1.13.6.2 \
    LUAROCKS_VERSION=2.4.4 \
    LUAROCKS_SRC_SHA256=3938df33de33752ff2c526e604410af3dceb4b7ff06a770bc4a240de80a1f934 \
    VAR_PREFIX=/var/nginx

RUN set -ex \
  && apk --no-cache add \
    libgcc \
    libpcrecpp \
    libpcre16 \
    libpcre32 \
    libssl1.0 \
    libstdc++ \
    openssl \
    pcre \
    curl \
    unzip \
    git \
    dnsmasq \
  && apk --no-cache add --virtual .build-dependencies \
    make \
    musl-dev \
    gcc \
    ncurses-dev \
    openssl-dev \
    pcre-dev \
    perl \
    readline-dev \
    zlib-dev \
    libc-dev \
  \
## OpenResty
  && curl -fsSL https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz -o /tmp/openresty.tar.gz \
  \
  && cd /tmp \
  && echo "${OPENRESTY_SRC_SHA256} *openresty.tar.gz" | sha256sum -c - \
  && tar -xzf openresty.tar.gz \
  \
  && cd openresty-* \
  && readonly NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
  && ./configure \
    --prefix=${OPENRESTY_PREFIX} \
    --http-client-body-temp-path=${VAR_PREFIX}/client_body_temp \
    --http-proxy-temp-path=${VAR_PREFIX}/proxy_temp \
    --http-log-path=${VAR_PREFIX}/access.log \
    --error-log-path=${VAR_PREFIX}/error.log \
    --pid-path=${VAR_PREFIX}/nginx.pid \
    --lock-path=${VAR_PREFIX}/nginx.lock \
    --with-luajit \
    --with-pcre-jit \
    --with-ipv6 \
    --with-http_ssl_module \
    --without-http_ssi_module \
    --with-http_realip_module \
    --without-http_scgi_module \
    --without-http_uwsgi_module \
    --without-http_userid_module \
    -j${NPROC} \
  && make -j${NPROC} \
  && make install \
  \
  && rm -rf /tmp/openresty* \
  \
## LuaRocks
  && curl -fsSL http://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz -o /tmp/luarocks.tar.gz \
  \
  && cd /tmp \
  && echo "${LUAROCKS_SRC_SHA256} *luarocks.tar.gz" | sha256sum -c - \
  && tar -xzf luarocks.tar.gz \
  \
  && cd luarocks-* \
  && ./configure \
    --prefix=${OPENRESTY_PREFIX}/luajit \
    --lua-suffix=${LUA_SUFFIX} \
    --with-lua=${OPENRESTY_PREFIX}/luajit \
    --with-lua-lib=${OPENRESTY_PREFIX}/luajit/lib \
    --with-lua-include=${OPENRESTY_PREFIX}/luajit/include/luajit-${LUAJIT_VERSION} \
  && make build \
  && make install \
  \
  && rm -rf /tmp/luarocks* \
  && rm -rf ~/.cache/luarocks \
## Post install
  && ln -sf ${NGINX_PREFIX}/sbin/nginx /usr/local/bin/nginx \
  && ln -sf ${NGINX_PREFIX}/sbin/nginx /usr/local/bin/openresty \
  && ln -sf ${OPENRESTY_PREFIX}/bin/resty /usr/local/bin/resty \
  && ln -sf ${OPENRESTY_PREFIX}/luajit/bin/luajit-* ${OPENRESTY_PREFIX}/luajit/bin/lua \
  && ln -sf ${OPENRESTY_PREFIX}/luajit/bin/luajit-* /usr/local/bin/lua  \
  && ln -sf ${OPENRESTY_PREFIX}/luajit/bin/luarocks /usr/local/bin/luarocks \
  && ln -sf ${OPENRESTY_PREFIX}/luajit/bin/luarocks-admin /usr/local/bin/luarocks-admin \
  && echo user=root >> /etc/dnsmasq.conf \
## Install lua-resty-openidc
  && cd ~/ \
  # Fix for https://github.com/zmartzone/lua-resty-openidc/issues/213#issuecomment-432471572
  && luarocks install lua-resty-hmac \
  && luarocks install lua-resty-openidc \
## Install lua-resty-xacml-pep
  && curl -fsSL https://raw.githubusercontent.com/zmartzone/lua-resty-xacml-pep/master/lib/resty/xacml_pep.lua -o /opt/openresty/lualib/resty/xacml_pep.lua \
## Cleanup
  && apk del .build-dependencies 2>/dev/null

WORKDIR $NGINX_PREFIX

CMD ["openresty", "-g", "daemon off; error_log /dev/stderr info;"]
