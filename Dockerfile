#FROM alpine:3.2
FROM gliderlabs/alpine
MAINTAINER Dimitrios Liappis <dimitrios.liappis (at) gmail.com>

RUN apk add --update bash rsyslog && rm -rf /var/cache/apk/*

RUN mkdir -p /etc/rsyslog.d/
RUN mkdir -p /var/socket/
RUN mkdir -p /var/spool/rsyslog/

EXPOSE 1514 1514/udp

COPY ./etc/rsyslog.conf /etc/rsyslog.conf

ENTRYPOINT ["rsyslogd"]
CMD ["-n", "-f", "/etc/rsyslog.conf"]
