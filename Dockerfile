FROM telegraf:1.40@sha256:90da3a5b81426230ed677f00823de0d55ce198ad7b5c2e099afc417ebc744642 AS telegraf

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
