FROM cloudflare/cloudflared as cloudflared

FROM ubuntu:jammy
RUN apt update && apt install -y iputils-ping netcat bind9-dnsutils inetutils-traceroute net-tools curl tcpdump && apt-get clean
COPY --from=cloudflared /usr/local/bin/cloudflared /usr/local/bin/cloudflared