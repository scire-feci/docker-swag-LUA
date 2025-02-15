# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.21

# Install build dependencies and Lua
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

# Download and compile NGINX with Lua module
RUN curl -O http://nginx.org/download/nginx-1.25.2.tar.gz && \
    tar -xvzf nginx-1.25.2.tar.gz && \
    cd nginx-1.25.2 && \
    ./configure \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_lua_module \
        --with-compat \
        --with-http_ssl_module \
        --with-http_v2_module && \
    make && make install && \
    cd .. && rm -rf nginx-1.25.2 nginx-1.25.2.tar.gz

# Remove default NGINX and link custom NGINX
RUN apk del nginx && \
    ln -sf /usr/local/nginx/sbin/nginx /usr/sbin/nginx

# Cleanup build dependencies
RUN apk del .build-deps && rm -rf /var/cache/apk/*

# Copy necessary files and expose ports
COPY root/ /
EXPOSE 80 443 25565
VOLUME /config
