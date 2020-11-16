FROM golang AS builder

ENV GO15VENDOREXPERIMENT 1
ENV CGO_ENABLED 0

RUN go get -u github.com/googlecloudplatform/gcsfuse

FROM alpine:latest  
RUN apk --no-cache add ca-certificates fuse
WORKDIR /root/
COPY --from=builder /go/bin/gcsfuse .
CMD ["./gcsfuse", "--version"]
