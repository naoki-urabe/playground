FROM golang:1.16.7-alpine
RUN apk update \
    && apk add --no-cache git
WORKDIR /go/src