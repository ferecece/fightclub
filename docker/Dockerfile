FROM debian:trixie-slim

LABEL org.opencontainers.image.title="THE LAST BALLAD" \
      org.opencontainers.image.description="Runtime image for the GTA Connected racing server"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    gzip \
    libgcc-s1 \
    libstdc++6 \
    python3 \
    tar \
    tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -d /home/container -m container

COPY entrypoint.sh /entrypoint.sh
COPY install-server.sh /opt/install-server.sh
RUN chmod +x /entrypoint.sh /opt/install-server.sh

# Wings runs the server process as the configured pterodactyl user.
# The installation container runs as root so it can write /mnt/server.
ENV USER=container HOME=/home/container
WORKDIR /home/container

STOPSIGNAL SIGTERM
CMD ["/bin/bash", "/entrypoint.sh"]
