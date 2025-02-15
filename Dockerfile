FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.21

RUN apk add --no-cache --virtual .build-deps \
    build-base \
    linux-headers \
    lua5.3-dev \
    luajit-dev \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    curl \
    && apk add --no-cache luajit

# Download NGINX and the Lua module
RUN curl -O http://nginx.org/download/nginx-1.25.2.tar.gz && \
    curl -L -O https://github.com/openresty/stream-lua-nginx-module/archive/refs/tags/v0.0.11.tar.gz && \
    tar -xvzf nginx-1.25.2.tar.gz && \
    tar -xvzf v0.0.11.tar.gz && \
    cd nginx-1.25.2 && \
    ./configure \
        --with-stream \
        --with-stream_ssl_module \
        --add-module=../stream-lua-nginx-module-0.0.11 \
        --with-compat \
        --with-http_ssl_module \
        --with-http_v2_module && \
    make && make install && \
    cd .. && rm -rf nginx-1.25.2 nginx-1.25.2.tar.gz v0.0.11.tar.gz stream-lua-nginx-module-0.0.11

RUN apk del .build-deps && rm -rf /var/cache/apk/*

COPY root/ /
EXPOSE 80 443 25565
VOLUME /config
