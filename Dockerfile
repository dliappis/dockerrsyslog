#FROM alpine:3.2
FROM gliderlabs/alpine
MAINTAINER Dimitrios Liappis <dimitrios.liappis (at) gmail.com>

RUN apk add --update bash rsyslog && rm -rf /var/cache/apk/*

# RUN addgroup -g 500 ec2-user
# RUN adduser -u 500 -G ec2-user -D ec2-user
RUN mkdir -p /etc/rsyslog.d/
RUN mkdir -p /var/spool/rsyslog/
RUN mkdir -p /var/log/rsyslog
# RUN chown -R 500:500 /var/log/rsyslog

EXPOSE 1514 1514/udp

COPY ./etc/rsyslog.conf /etc/rsyslog.conf

ENTRYPOINT ["rsyslogd"]
CMD ["-n", "-f", "/etc/rsyslog.conf"]
