FROM arm32v7/debian:buster

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y && apt install -y debootstrap f2fs-tools fdisk

RUN ["mkdir", "/opt/srobo"]
WORKDIR /opt/srobo
ADD build.sh /opt/srobo/
COPY stage* /opt/srobo/

