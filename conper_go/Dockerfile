# Etapa de compilación
FROM golang:1.16-alpine AS build

WORKDIR /src
COPY . .

RUN CGO_ENABLED=0 go build -o /bin/app

# Etapa de producción
FROM scratch
COPY --from=build /bin/app /bin/app

ENTRYPOINT ["/bin/app"]
