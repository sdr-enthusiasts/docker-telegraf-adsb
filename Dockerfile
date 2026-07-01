FROM telegraf:1.39@sha256:0aee710d660970fc70927a7bae1306e238aea7b6e7ba264b04cb52c197492592 AS telegraf

RUN touch /tmp/emptyfile

FROM ghcr.io/sdr-enthusiasts/docker-baseimage:base

ENV \
    S6_KILL_GRACETIME=1000

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# add telegraf binary
COPY --from=telegraf /usr/bin/telegraf /usr/bin/telegraf

RUN set -x && \
    mkdir -p /etc/telegraf/telegraf.d && \
    # document telegraf version
    bash -ec "telegraf --version >> /VERSIONS" && \
    cat /VERSIONS

COPY rootfs/ /
