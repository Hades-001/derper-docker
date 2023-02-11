FROM --platform=${TARGETPLATFORM} golang:1.20-alpine as builder

ENV CGO_ENABLED=0
ARG TAG

WORKDIR /root

RUN set -ex && \
    apk add --no-cache git ca-certificates libcap && \
    git clone https://github.com/tailscale/tailscale.git tailscale && \
    cd ./tailscale/cmd/derper && \
    git fetch --all --tags && \
    git checkout tags/${TAG} && \
    rm -f derper && \
    go build -ldflags "-s -w -X main.version=${TAG}" -trimpath -o derper && \
    setcap CAP_NET_BIND_SERVICE=+eip derper

FROM --platform=${TARGETPLATFORM} alpine:3.17
COPY --from=builder /root/tailscale/cmd/derper/derper /usr/bin/

ENV DERP_ADDR               :443
ENV DERP_HTTP_PORT          80
ENV DERP_STUN_PORT          3478
ENV DERP_CONFIG_PATH        /etc/derper/config.json
ENV DERP_CERT_MODE          letsencrypt
ENV DERP_CERT_DIR           /etc/derper/ssl
ENV DERP_HOSTNAME           derp.tailscale.com
ENV DERP_RUN_STUN           true
ENV DERP_RUN_DERP           true
ENV DERP_VERIFY_CLIENTS     false

RUN apk add --no-cache ca-certificates su-exec tzdata iptables iproute2 ip6tables

ENV TZ=Asia/Shanghai
RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone

CMD /usr/bin/derper \
    --a="${DERP_ADDR}" \
    --http-port="${DERP_HTTP_PORT}" \
    --stun-port="${DERP_STUN_PORT}" \
    --c="${DERP_CONFIG_PATH}" \
    --certmode="${DERP_CERT_MODE}" \
    --certdir="${DERP_CERT_DIR}" \
    --hostname="${DERP_HOSTNAME}" \
    --stun="${DERP_RUN_STUN}" \
    --derp="${DERP_RUN_DERP}" \
    --verify-clients="${DERP_VERIFY_CLIENTS}"
