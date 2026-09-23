FROM ubuntu:resolute AS ciron_builder
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get install -y --no-install-recommends curl ca-certificates build-essential git curl pkg-config libssl-dev protobuf-compiler && apt-get clean
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN cd / && git clone --branch k8s https://github.com/sctg-development/ciron.git && . ~/.cargo/env && cd ciron && cargo build --release

FROM cloudflare/cloudflared AS cloudflared

FROM ubuntu:resolute
RUN apt update && apt install -y iputils-ping netcat-traditional bind9-dnsutils inetutils-traceroute net-tools curl tcpdump ca-certificates && apt-get clean
COPY --from=cloudflared /usr/local/bin/cloudflared /usr/local/bin/cloudflared
RUN curl -L https://dl.min.io/client/mc/release/linux-$(dpkg --print-architecture)/mc > /usr/local/bin/mc && chmod +x /usr/local/bin/mc
COPY --from=ismogroup/busybox:1.37.0-php-8.3-apache /busybox-1.37.0/_install/bin/busybox /bin/busybox
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/resolute.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null && \
    # Add the tailscale repository \
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/resolute.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list && \
    # Install Tailscale \
    apt-get update -y && apt-get install -y tailscale && \
    mkdir -p /var/lib/tailscale && \
    mkdir -p /run/tailscale
COPY --from=ciron_builder /ciron/target/release/cirond /usr/sbin/cirond
COPY --from=ciron_builder /ciron/target/release/cironctl /usr/sbin/cironctl
RUN mkdir -p /etc/ciron
COPY ciron.toml /etc/ciron/ciron.toml
RUN  /bin/busybox --install -s
