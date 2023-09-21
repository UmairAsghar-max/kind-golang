FROM ubuntu:latest

ARG GO_VERSION
ENV GO_VERSION=${GO_VERSION}

RUN apt-get update
RUN apt-get install -y wget git gcc

RUN wget -P /tmp "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz"

RUN tar -C /usr/local -xzf "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"
RUN rm "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN apt-get update && apt-get install apt-utils tini git curl vagrant build-essential -y
RUN apt-get install wget cmake g++ pkg-config git vim-common libwebsockets-dev libjson-c-dev libssl-dev -y && \
    git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && mkdir build && cd build && \
    cmake .. && \
    make && make install

RUN apt-get install virtualbox -y

RUN vagrant plugin install vagrant-libvirt

EXPOSE 7681
WORKDIR /root

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["ttyd", "-W", "bash"]

