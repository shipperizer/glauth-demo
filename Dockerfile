FROM --platform=$BUILDPLATFORM golang:1.20-bullseye AS builder

LABEL org.opencontainers.image.source=https://github.com/shipperizer/glauth-demo

ARG SKAFFOLD_GO_GCFLAGS
ARG TARGETOS
ARG TARGETARCH

ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH
ENV GO111MODULE=on
ENV CGO_ENABLED=1

WORKDIR /var/app

COPY . .

RUN apt update && apt install -y libpam0g-dev
RUN make build

RUN ls -la /var/app/glauth/v2/bin/${GOOS}${GOARCH}


FROM gcr.io/distroless/base
# FROM gcr.io/distroless/base:debug
# TODO switch to use nonroot, current issue is file creation, add --chown=65532:65532 on copy
# FROM gcr.io/distroless/static:nonroot

ARG SKAFFOLD_GO_GCFLAGS
ARG TARGETOS
ARG TARGETARCH
ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH

LABEL org.opencontainers.image.source=https://github.com/shipperizer/glauth-demo

WORKDIR /

COPY --from=builder /var/app/glauth/v2/bin/${GOOS}${GOARCH}/glauth /glauth
# COPY --from=builder /var/app/glauth/v2/bin/${GOOS}${GOARCH}/postgres.so /postgres.so
COPY --from=builder /var/app/glauth/v2/sample-simple.cfg /config.cfg

CMD ["/glauth", "-c", "config.cfg"]
