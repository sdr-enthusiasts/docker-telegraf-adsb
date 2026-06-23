FROM telegraf:1.39@sha256:9768f82ebf8bde6da0d61ba220c00161750740c3e322b507a5982b89bbfca99a AS telegraf

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
