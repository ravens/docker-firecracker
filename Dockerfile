FROM ubuntu:18.04
MAINTAINER Yan Grunenberger <yan@grunenberger.net>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -yq dist-upgrade
RUN apt-get -qy install curl socat
WORKDIR /root
ENV FIRECRACKERVERSION 0.14.0
RUN curl -LOJ https://github.com/firecracker-microvm/firecracker/releases/download/v${FIRECRACKERVERSION}/firecracker-v${FIRECRACKERVERSION}
RUN mv firecracker-v${FIRECRACKERVERSION} firecracker
RUN chmod ugo+x firecracker
ENTRYPOINT ["/root/firecracker"]