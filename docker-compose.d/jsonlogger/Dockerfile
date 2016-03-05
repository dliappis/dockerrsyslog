FROM alpine:3.3
MAINTAINER Dimitrios Liappis <dimitrios.liappis <at) gmail.com>

RUN apk add --update bash && rm -rf /var/cache/apk/*

RUN echo '{"operation":"authentication","result":"failed","reason":"No authz rule was matched","remoteaddr":"85.74.54.81","type":"repository","name":"dliappis/onemorehelloworld","service":"token-service","actions":["pull"]}' >>/testoutput.json
RUN echo '{"operation":"authentication","result":"succeeded","remoteaddr":"85.74.48.253","type":"repository","name":"elastic/image","service":"token-service","actions":["pull"]}' >>/testoutput.json

CMD ["cat", "/testoutput.json"]
