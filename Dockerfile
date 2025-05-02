FROM cloudflare/cloudflared as cloudflared

FROM ubuntu:noble
RUN apt update && apt install -y iputils-ping netcat bind9-dnsutils inetutils-traceroute net-tools curl tcpdump && apt-get clean
COPY --from=cloudflared /usr/local/bin/cloudflared /usr/local/bin/cloudflared
RUN curl -L https://dl.min.io/client/mc/release/linux-$(dpkg --print-architecture)/mc > /usr/local/bin/mc && chmod +x /usr/local/bin/mc
COPY --from=ismogroup/busybox:1.37.0-php-8.3-apache /busybox-1.37.0/_install/bin/busybox /bin/busybox
RUN  /bin/busybox --install -s