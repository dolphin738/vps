FROM golang:latest AS builder
COPY get_wgsd_coredns.sh get_wgsd_coredns.sh
RUN bash get_wgsd_coredns.sh

FROM alpine:latest
LABEL org.opencontainers.image.authors="https://github.com/dolphin738"
COPY --from=builder /go/coredns /usr/local/bin/coredns

ENV TZ=Asia/Shanghai
RUN apk add --no-cache ca-certificates tzdata

VOLUME [ "/config" ]
WORKDIR /usr/local/bin
CMD [ "coredns" ]