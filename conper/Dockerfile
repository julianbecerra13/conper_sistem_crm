# Etapa de compilación
FROM ubuntu:18.04 AS build

WORKDIR /app

# Prerequisites
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget

# Set up new user
RUN useradd -ms /bin/bash developer
USER root

# Download and extract Flutter SDK
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.5-stable.tar.xz
RUN tar xf flutter_linux_3.10.5-stable.tar.xz
ENV PATH "$PATH:/app/flutter/bin"

# Copy project files
COPY . .

# Set permissions for project directory
RUN chown -R developer:developer /app

USER developer

# Run basic check to download Dart SDK
RUN flutter doctor

RUN flutter pub get
RUN flutter build web --release

# Etapa de producción
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
