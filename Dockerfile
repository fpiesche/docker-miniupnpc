FROM alpine:3.16.2
RUN apk --no-cache add miniupnpc grep

ADD entrypoint.sh /usr/bin/entrypoint.sh

CMD [ "/bin/sh", "/usr/bin/entrypoint.sh" ]
