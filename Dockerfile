FROM telegraf:1.39@sha256:ac66e6482c0644765c12904ce2f42ce3f3702f72e905b1894120b51b12ae30c9 AS telegraf

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
