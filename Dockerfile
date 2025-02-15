FROM openresty/openresty:alpine

# Install required tools
RUN apk add --no-cache curl bash

# Copy your SWAG configs and setup
COPY root/ /

# Expose necessary ports
EXPOSE 80 443 25565

# Set volume for config
VOLUME /config
