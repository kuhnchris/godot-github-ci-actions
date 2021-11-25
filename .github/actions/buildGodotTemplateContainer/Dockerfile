FROM ubuntu:latest
COPY entrypoint.sh /entrypoint.sh
RUN chmod 0777 /entrypoint.sh
RUN /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/entrypoint.sh" ]