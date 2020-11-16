FROM alpine AS downloader

RUN apk add curl && \
    curl -L -O https://github.com/voutcn/megahit/releases/download/v1.2.9/MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz && \
    tar xf MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz

FROM python:2-alpine
COPY --from=downloader /MEGAHIT-1.2.9-Linux-x86_64-static/bin/* /usr/local/bin/
ENTRYPOINT ["megahit"]
