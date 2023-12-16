# ubuntu-net-tools-image

This is a very basic container with some tools useful for debugging kubernetes network.

- iputils-ping
- netcat
- bind9-dnsutils
- inetutils-traceroute
- net-tools
- curl
- tcpdump
- cloudflared
- minio mc

## Docker

`docker run -it highcanfly/net-tools`

## Kubernetes

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: shell
  namespace: sandbox
spec:
  containers:
  - name: shell
    image: highcanfly/net-tools
    imagePullPolicy: Always
    command: ["/bin/sh"]
    args: ["-c", "cd ~/ && touch file.txt && mknod -m 777 fifo p && cat fifo | netcat -k -l 8000 > fifo && sleep infinity"]
  hostNetwork: false
  dnsPolicy: ClusterFirst
```
