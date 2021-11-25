FROM ubuntu:latest
# add packages
#RUN apk add unzip
RUN apt-get update && apt-get install -y unzip zip wget
# add script, run
COPY entrypoint.sh /entrypoint.sh
RUN chmod 0777 /entrypoint.sh
RUN /entrypoint.sh
# ensuring people overwrite the entrypoint
COPY noentrypoint.sh /entrypoint.sh
RUN chmod 0777 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/entrypoint.sh" ]