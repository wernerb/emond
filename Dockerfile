FROM docker.io/library/alpine:3.10
RUN apk --update add --no-cache git alpine-sdk wiringpi wiringpi-dev curl-dev mosquitto-clients
ADD . /emond
RUN make -C emond install

FROM docker.io/library/alpine:3.10
RUN apk --update add --no-cache wiringpi mosquitto-clients
COPY --from=0 /usr/local/bin/emond /usr/local/bin/emond
# contains emond.dat
VOLUME ["/media/data"]
WORKDIR /var/lib/emond
ENTRYPOINT ["/usr/local/bin/emond"]
