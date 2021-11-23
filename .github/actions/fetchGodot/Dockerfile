FROM alpine:latest
RUN apk add unzip

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0777 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/entrypoint.sh" ]