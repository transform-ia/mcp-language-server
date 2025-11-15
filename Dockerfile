# syntax=docker/dockerfile:1

FROM golang:1.24.2-alpine3.21 AS builder
WORKDIR /workdir
COPY . .
RUN --mount=type=cache,target=/go/pkg/mod \
  go build -v -o mcp-language-server .

FROM transformia/upx:5.0.0 AS compressor
COPY --from=builder /workdir/mcp-language-server /mcp-language-server
RUN upx -9 -o /mcp-language-server.compressed /mcp-language-server

FROM alpine:3.21.3
COPY --from=compressor /mcp-language-server.compressed /usr/local/bin/mcp-language-server
ENTRYPOINT ["/usr/local/bin/mcp-language-server"]
