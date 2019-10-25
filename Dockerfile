FROM docker.io/library/alpine:3.10
RUN apk --update add --no-cache git alpine-sdk linux-headers mosquitto-clients
#RUN apk --update add --no-cache wiringpi-dev wiringpi
# START section specific to odroid wiringpi, comment out if not needed
RUN git clone https://github.com/hardkernel/wiringPi
RUN cd wiringPi && sed -i '/exit 1/d' ./build
RUN cd wiringPi && sed -i '/make uninstall/d' ./build
RUN cd wiringPi && ./build static || true
# END
ADD . /emond
RUN make -C emond install
# contains emond.dat
VOLUME ["/media/data"]
WORKDIR /var/lib/emond
ENTRYPOINT ["/usr/local/bin/emond"]
