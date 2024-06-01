FROM freepascal/fpc:3.2.2-buster-full AS build
WORKDIR /build
COPY src ./src
COPY build.sh .
RUN ./build.sh

FROM alpine:3.20 AS runtime
RUN apk add --no-cache libc6-compat
RUN adduser -D web
USER web
WORKDIR /app
COPY --from=build /build/out/app .
EXPOSE 8080
ENTRYPOINT ["/app/app"]
