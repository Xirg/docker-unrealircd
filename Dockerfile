FROM alpine

LABEL maintainer="Xirg" mail="xirg.laptop@gmail.com"
LABEL description="Unrealircd"
LABEL version="1.0"

ARG PKG="wget gcc make binutils libc6-compat g++ openssl-dev openssl curl curl-dev"
ARG VER="5.0.7"
ARG UID=1000

COPY ./config.settings /tmp/config.settings

WORKDIR /usr/src/ircd
RUN set -x \
    && apk add --no-cache --virtual build ${PKG} && apk add --no-cache libcurl \
    && wget -O /tmp/unrealircd https://www.unrealircd.org/downloads/unrealircd-latest.tar.gz \
    && tar xvfz /tmp/unrealircd \
    && cd */ \
    && cp /tmp/config.settings ./config.settings \
    && echo "$PWD" \
    && ./Config -quick \
    && make -j$(nproc) && make install \
    && rm -rf /usr/src/ircd \
    && apk del build \
    && addgroup -S unreal && adduser -u ${UID} -S unreal -G unreal

WORKDIR /ircd
RUN set -x \
    && chown -R unreal:unreal /ircd /app
USER unreal
CMD ["/bin/sh" ]
