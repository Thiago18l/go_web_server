ARG BASE_IMAGE=docker.io/library/debian:bullseye-slim

FROM ${BASE_IMAGE} as BASE

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN groupadd -g 999 dvop_user && \
    useradd -r -u 999 -g dvop_user dvop_user && \
    mkdir -p /home/dvop_user && \
    chown dvop_user:0 /home/dvop_user &&\
    chmod g=u /home/dvop_user &&\ 
    apt-get update && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV USER=dvop_user
USER 999
WORKDIR /home/dvop_user

FROM golang:1.16.6-alpine3.14 as APP_BUILDER

WORKDIR /go/src/github.com/thiago18l/web-server

COPY go.mod go.mod

COPY ./src ./src
RUN cd ./src && CGO_ENABLE=0 GOOS=linux go build -tags netgo -a -v -installsuffix cgo -o main .

FROM BASE

COPY --from=APP_BUILDER /go/src/github.com/thiago18l/web-server/src/main /home/dvop_user/main
EXPOSE 8080
ENTRYPOINT [ "/tini", "--" ]
CMD [ "./main" ]
USER 999


