# Etapa de compilación
FROM cirrusci/flutter:latest AS build

WORKDIR /app

COPY . .

RUN flutter pub get
RUN flutter build web --release

# Etapa de producción
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
