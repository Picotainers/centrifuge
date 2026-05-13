FROM ubuntu:22.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG CENTRIFUGE_VERSION=v1.0.4.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    g++ \
    gcc \
    git \
    make \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN git clone --depth 1 --branch ${CENTRIFUGE_VERSION} https://github.com/DaehwanKimLab/centrifuge.git
WORKDIR /build/centrifuge
RUN make

FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    zlib1g \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/centrifuge/centrifuge /usr/local/bin/centrifuge
COPY --from=builder /build/centrifuge/centrifuge-build /usr/local/bin/centrifuge-build
COPY --from=builder /build/centrifuge/centrifuge-inspect /usr/local/bin/centrifuge-inspect
COPY --from=builder /build/centrifuge/centrifuge-kreport /usr/local/bin/centrifuge-kreport

WORKDIR /data
ENTRYPOINT ["centrifuge"]
