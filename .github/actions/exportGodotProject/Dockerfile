FROM ubuntu:latest
RUN apt-get update && apt-get install -y unzip wget zip

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0777 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/entrypoint.sh" ]