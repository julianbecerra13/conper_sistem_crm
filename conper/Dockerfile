# Etapa de compilación
FROM cirrusci/flutter:stable AS build

WORKDIR /app

COPY . .

# Instalar Dart SDK
RUN wget https://dart.dev/tools/sdk/archive/2.19.5/dart-sdk-linux-x64.zip
RUN unzip dart-sdk-linux-x64.zip -d /usr/local
ENV PATH "$PATH:/usr/local/dart-sdk/bin"

RUN flutter pub get
RUN flutter build web --release

# Etapa de producción
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
