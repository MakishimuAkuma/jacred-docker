FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:6.0 AS build

ARG TARGETARCH

WORKDIR /build

ADD https://github.com/immisterio/jacred-fdb.git ./jacred-fdb

RUN case "$TARGETARCH" in \
        "amd64") dotnet publish ./jacred-fdb --os linux -a musl-x64 -c Release --self-contained true -o /build/dist ;; \
        "arm") dotnet publish ./jacred-fdb --os linux -a musl-arm -c Release --self-contained true -o /build/dist ;; \
        "arm64") dotnet publish ./jacred-fdb --os linux -a musl-arm64 -c Release --self-contained true -o /build/dist ;; \
    esac

FROM alpine:latest

WORKDIR /app

RUN apk add --no-cache --update libstdc++ libgcc icu

COPY --from=build /build/dist /app
COPY ./init.conf /app/init.conf
COPY ./entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

VOLUME ["/app/Data", "/app/config"]

EXPOSE 9118

ENTRYPOINT [ "/entrypoint.sh" ]
