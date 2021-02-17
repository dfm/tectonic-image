FROM rust:1.50 as builder
RUN apt-get update \
 && apt-get install -y \
    libfontconfig1-dev \
    libgraphite2-dev \
    libharfbuzz-dev \
    libicu-dev \
    libssl-dev \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

ARG TECTONIC_VERSION=0.4.1
RUN cargo install --vers ${TECTONIC_VERSION} tectonic

FROM debian:buster-slim
RUN apt-get update \
 && apt-get install -y \
    libfontconfig1-dev \
    libgraphite2-dev \
    libharfbuzz-dev \
    libicu-dev \
    libssl-dev \
    zlib1g-dev \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# RUN mkdir -p /home/tectonic/.cache && \
#     adduser --home /home/tectonic --no-create-home --disabled-password tectonic && \
#     chown -R tectonic /home/tectonic
# USER tectonic

COPY --from=builder /usr/local/cargo/bin/tectonic /usr/local/bin/tectonic

ENTRYPOINT [ "tectonic" ]
