FROM golang:1.24-bullseye AS builder
ARG TARGETOS
ARG TARGETARCH
WORKDIR /app

# Install certificates and update ca-certificates
RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# Copy go mod files first for better caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source and build
COPY . .
ENV CGO_ENABLED=0
ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH
RUN go build -o /tmp/cu ./cmd/cu

FROM debian:12-slim
RUN apt-get update && \
    apt-get install -y ca-certificates git && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /tmp/cu /usr/local/bin/cu
RUN chmod +x /usr/local/bin/cu

ENTRYPOINT ["/usr/local/bin/cu"]
CMD ["stdio"]
