FROM --platform=${TARGETPLATFORM} golang:1.19-alpine as builder
ENV CGO_ENABLED=0
ARG TAG

WORKDIR /root

RUN set -ex && \
    apk add --no-cache git && \
    git clone https://github.com/tailscale/tailscale.git tailscale && \
    cd ./tailscale && \
    git fetch --all --tags && \
    git checkout tags/${TAG} && \
    go install ./cmd/derper

FROM --platform=${TARGETPLATFORM} alpine:3.17
COPY --from=builder /go/bin/derper /bin/derper

ENV DERP_DOMAIN             your-hostname.com
ENV DERP_CERT_MODE          letsencrypt
ENV DERP_CERT_DIR           /etc/ssl
ENV DERP_ADDR               :443
ENV DERP_STUN               true
ENV DERP_STUN_PORT          3478
ENV DERP_HTTP_PORT          80
ENV DERP_VERIFY_CLIENTS     false

RUN apk add --no-cache ca-certificates su-exec tzdata iptables iproute2 ip6tables

VOLUME ["/etc/ssl"]

WORKDIR /etc/ssl

ENV TZ=Asia/Shanghai
RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
	echo "${TZ}" > /etc/timezone

ENV PUID=1000 PGID=1000 HOME=/etc/ssl

COPY docker-entrypoint.sh /bin/entrypoint.sh
RUN chmod a+x /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]

CMD /bin/derper --hostname="${DERP_DOMAIN}" \
    --certmode="${DERP_CERT_MODE}" \
    --certdir="${DERP_CERT_DIR}" \
    --a="${DERP_ADDR}" \
    --stun="${DERP_STUN}"  \
    --stun-port="${DERP_STUN_PORT}" \
    --http-port="${DERP_HTTP_PORT}" \
    --verify-clients="${DERP_VERIFY_CLIENTS}"
