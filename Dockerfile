FROM debian:stable-slim as builder

MAINTAINER Eric <eric@exacer.be>
LABEL Description="A Docker image for mjpg_streamer." Version="0.3"

# Build mjpg_streamer

RUN apt-get update && apt-get install -y --no-install-recommends \
        make git gcc g++ cmake libjpeg62-turbo-dev ca-certificates \
        && rm -rf /var/lib/apt/lists/ \
        && apt-get autoremove -y && apt-get autoclean -y

RUN git clone https://github.com/jacksonliam/mjpg-streamer.git 

WORKDIR /mjpg-streamer/mjpg-streamer-experimental

RUN make \ 
    && make install \
    && chmod +x docker-start.sh

# Need to run container with the device: docker run -t -i -p 8080:8080/tcp --device=/dev/video0 image:tag

FROM debian:stable-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends libjpeg62-turbo \
 && rm -rf /var/lib/apt/lists/ \
 && apt-get autoremove -y && apt-get autoclean -y

COPY --from=builder /usr/local/bin/mjpg_streamer   /usr/local/bin/mjpg_streamer
COPY --from=builder /usr/local/lib/mjpg-streamer   /usr/local/lib/mjpg-streamer
COPY --from=builder /usr/local/share/mjpg-streamer /usr/local/share/mjpg-streamer
COPY                simple                         /usr/local/share/mjpg-streamer/simple
COPY                docker-start.sh                /docker-start.sh

RUN chmod +x /docker-start.sh

EXPOSE 8080/TCP
ENV LD_LIBRARY_PATH=/usr/local/share/mjpg-streamer
ENTRYPOINT ["/docker-start.sh"]
