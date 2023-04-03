FROM ubuntu:jammy
RUN apt update && apt install -y iputils-ping netcat bind9-dnsutils inetutils-traceroute net-tools && apt-get clean