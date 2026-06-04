# Bazzite Desktop + linux-surface — Surface Pro 9 (Intel Iris Xe)
FROM scratch AS ctx
COPY build_files /
COPY system_files /files

# Intel iGPU desktop (NOT nvidia) — matches Surface Pro 9 i7-1265U
FROM ghcr.io/ublue-os/bazzite:stable

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    sed -i 's/\r$//' /ctx/build.sh /ctx/cleanup.sh && \
    chmod +x /ctx/build.sh /ctx/cleanup.sh && \
    bash /ctx/build.sh && \
    bash /ctx/cleanup.sh && \
    ostree container commit

RUN bootc container lint
