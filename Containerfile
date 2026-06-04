# Universal Blue image-template: https://github.com/ublue-os/image-template
FROM scratch AS ctx
COPY build_files /
COPY system_files /files

# Surface Pro 9 = Intel Iris Xe — standard Bazzite Desktop (not nvidia, not deck)
FROM ghcr.io/ublue-os/bazzite:stable

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

RUN bootc container lint
