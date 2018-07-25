# docker build -t grpc-server ./server --build-arg app_env=dev
FROM golang:1.8

ARG app_env
ENV APP_ENV $app_env

# Installing ubuntu packages
RUN apt-get update && apt-get install -y \
    unzip 


# Moving share resources and scripts
COPY ./micro-minding-shared /go/src/github.com/hannesrabo/micro-minding/micro-minding-shared
WORKDIR /go/src/github.com/hannesrabo/micro-minding

# Install protobuf and protobuf for go
RUN ./micro-minding-shared/build/install-protobuff-ubuntu.sh
RUN go get -u google.golang.org/grpc
RUN go get -u github.com/golang/protobuf/protoc-gen-go
RUN export PATH=$PATH:$GOPATH/bin


######################################################################
COPY ./micro-minding-grpc_gateway /go/src/github.com/hannesrabo/micro-minding/micro-minding-grpc_gateway

# Compiling the protobuffer for gRPC
RUN ./micro-minding-grpc_gateway/build/build-protobuff.sh

# Installing and building go code
WORKDIR /go/src/github.com/hannesrabo/micro-minding/micro-minding-grpc_gateway/app
RUN go get ./
RUN go build

# Running the go code in an interactive session that reloads on changes (for dev)
CMD if [ ${APP_ENV} = production ]; \
    then \
    app; \
    else \
    go get github.com/pilu/fresh && \
    fresh; \
    fi

# Expose the port
EXPOSE 8081