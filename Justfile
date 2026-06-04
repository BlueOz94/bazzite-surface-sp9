image_name := "bazzite-surface-sp9"
default_tag := "stable"
bib_image := "quay.io/centos-bootc/bootc-image-builder:latest"

build target_image=image_name tag=default_tag:
    podman build -t {{target_image}}:{{tag}} -f Containerfile .

build-qcow2 target_image=image_name tag=default_tag:
    bootc-image-builder build --target-arch x86_64 --type qcow2 --image {{target_image}}:{{tag}}

clean:
    rm -rf output/ *.qcow2 *.iso
