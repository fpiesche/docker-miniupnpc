# MiniUPNPC client and port forwarder

![build](https://github.com/fpiesche/docker-miniupnpc/actions/workflows/main.yml/badge.svg)



# Quick reference

-   **Image Repositories**:
    - Docker Hub: [`florianpiesche/miniupnpc`](https://hub.docker.com/r/florianpiesche/miniupnpc)  
    - GitHub Packages: [`ghcr.io/fpiesche/miniupnpc`](https://ghcr.io/fpiesche/miniupnpc)  

-   **Maintained by**:  
	[Florian Piesche](https://github.com/fpiesche)

-	**Where to file issues**:  
    [https://github.com/fpiesche/docker-miniupnpc/issues](https://github.com/fpiesche/docker-miniupnpc/issues) (Docker images)

-   **Dockerfile**:
    [https://github.com/fpiesche/docker-miniupnpc/blob/main/Dockerfile](https://github.com/fpiesche/docker-miniupnpc/blob/main/Dockerfile)

-	**Supported architectures**:
    Each image is a multi-arch manifest for the following architectures:
    `amd64`, `arm64`, `armv7`, `armv6`

-	**Source of this description**: [Github README](https://github.com/fpiesche/docker-miniupnpc/tree/main/README.md) ([history](https://github.com/fpiesche/docker-miniupnpc/commits/main/README.md))

# Supported tags

-   `latest` is built whenever there are changes to this repository (i.e. the entrypoint script or the Dockerfile). This will most frequently happen when a new Alpine Linux release becomes available.

# How to use this image

The default command, `/usr/bin/entrypoint.sh`, takes configuration from some environment variables and will automatically forward the specified ports to the given IP address using UPNP. It is also possible to specify an IGD device.

For the automatic detection of the IGD device to work, this image needs to be run with host network privileges (e.g. the `--net=host` command-line parameter for `docker run`).

```console
$ docker run \
  --rm -it \
  --net=host
  -e PORTS=80,443 \
  -e TARGET_IP=192.168.0.42 \
  florianpiesche/miniupnpc
```

## Configuration environment variables

| Variable         | Example                                | Notes                                                  |
| :--------------- | :------------------------------------: | :----------------------------------------------------- |
| `PORTS`          | `80,443`                               | A comma-separated list of ports to forward.            |
| `TARGET_IP`      | `192.168.0.42`                         | The local IP address the ports should be forwarded to. |
| `IGD_DEVICE_URL` | `http://192.168.0.1:5000/rootDesc.xml` | (default: auto-detect) The `rootDesc.xml` file on the IGD handling the port forwarding. |
| `SERVICE_NAME`   | `HTTP server`                          | (default: "Docker Service") A string containing a  description for the port forward. |
| `LIFETIME`       | `3600`                                 | (default: 3600) The lifetime, in seconds, of the port forward. Once this time expires, the port forward is deleted. |
