FROM alpine:3.18.0
RUN apk --no-cache add miniupnpc grep

ADD entrypoint.sh /usr/bin/entrypoint.sh

CMD [ "/bin/sh", "/usr/bin/entrypoint.sh" ]
