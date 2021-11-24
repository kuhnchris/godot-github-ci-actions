FROM alpine:latest
RUN apk add unzip libc6-compat
COPY entrypoint.sh /entrypoint.sh
RUN chmod 0777 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/entrypoint.sh" ]