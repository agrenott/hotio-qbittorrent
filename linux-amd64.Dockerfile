FROM cr.hotio.dev/hotio/base@sha256:a5b4a850b6128d497dd55ea28290133352a80b9992a29e0a6e7918b4021d2ab5

ENV VPN_ENABLED="false" VPN_LAN_NETWORK="" VPN_CONF="wg0" VPN_ADDITIONAL_PORTS="" WEBUI_PORTS="8080/tcp,8080/udp" PRIVOXY_ENABLED="false" S6_SERVICES_GRACETIME=180000

EXPOSE 8080

RUN ln -s "${CONFIG_DIR}" "${APP_DIR}/qBittorrent"

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main privoxy iptables iproute2 openresolv wireguard-tools && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community ipcalc

ARG FULL_VERSION

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.15/community libtorrent-rasterbar && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing qbittorrent-nox=${FULL_VERSION}

ARG VUETORRENT_VERSION
RUN curl -fsSL "https://github.com/wdaan/vuetorrent/releases/download/v${VUETORRENT_VERSION}/vuetorrent.zip" > "/tmp/vuetorrent.zip" && \
    unzip "/tmp/vuetorrent.zip" -d "${APP_DIR}" && \
    rm "/tmp/vuetorrent.zip" && \
    chmod -R u=rwX,go=rX "${APP_DIR}/vuetorrent"

COPY root/ /
