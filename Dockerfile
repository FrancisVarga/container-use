FROM --platform=$BUILDPLATFORM golang AS builder
ARG TARGETOS
ARG TARGETARCH
WORKDIR /w
COPY . .
ENV CGO_ENABLED=0
ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH
ENV GOPROXY=direct
ENV GOSUMDB=off
RUN --mount=type=cache,target=/go/pkg/mod --mount=type=cache,target=/root/.cache/go-build \
    if [ "$TARGETOS" = "windows" ]; then \
        go build -o /tmp/cu.exe ./cmd/cu; \
    else \
        go build -o /tmp/cu ./cmd/cu; \
    fi

FROM scratch
ARG TARGETOS
COPY --from=builder /tmp/cu* .
