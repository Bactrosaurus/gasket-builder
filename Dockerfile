FROM ubuntu:24.04 AS build-stage

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -q -y --no-install-recommends git curl devscripts dkms dh-dkms build-essential debhelper

WORKDIR /build
COPY kernel-patches.patch /build/kernel-patches.patch

RUN git clone https://github.com/google/gasket-driver.git
RUN cd gasket-driver && git apply -v /build/kernel-patches.patch
RUN cd gasket-driver && debuild -us -uc -tc -b

FROM scratch AS export-stage
COPY --from=build-stage /build/*.deb .
