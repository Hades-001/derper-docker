FROM --platform=${TARGETPLATFORM} golang:1.19-bullseye as builder

ARG CGO_ENABLED=0
ARG TAG
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /root

RUN set -ex && \
    apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates git libcap2-bin && \
    git clone https://github.com/tailscale/tailscale.git tailscale && \
    cd ./tailscale/cmd/derper && \
    git fetch --all --tags && \
    git checkout tags/${TAG} && \
    go build -ldflags "-s -w -X main.version=${TAG}" -trimpath -o derper && \
    setcap CAP_NET_BIND_SERVICE=+eip derper

FROM --platform=${TARGETPLATFORM} gcr.io/distroless/base-debian11
COPY --from=builder /root/tailscale/cmd/derper/derper /usr/bin/

ENV TZ=Asia/Shanghai

CMD [ "/usr/bin/derper" ]