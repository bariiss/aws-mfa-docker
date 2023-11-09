# Use Alpine Linux as the base image
FROM alpine:latest

# Install build dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    expect \
    make \
    && pip install --upgrade pip \
    && pip install awscli \
    && pip install --no-cache-dir aws-mfa

# Add the edge/testing repository and install oathtool
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache oath-toolkit-oathtool

# Set the working directory
WORKDIR /root

# Create the .aws directory and touch the credentials and config files
RUN mkdir -p .aws && touch .aws/credentials .aws/config

# Copy the Makefile into the Docker image
COPY Docker.mk Makefile

# Define an entrypoint script
# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

ENTRYPOINT ["make", "aws-mfa"]