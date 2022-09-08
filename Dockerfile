FROM golang:1.19.1 as builder
COPY go.* /src/
COPY *.go /src/
COPY vendor /src/vendor
WORKDIR /src
RUN go test &&\
    CGO_ENABLED=0 go build -mod=vendor -o k8s-mutate-image-and-policy-webhook .

FROM scratch
COPY --from=builder /etc/ssl/certs/ /etc/ssl/certs/
COPY --from=builder /src/k8s-mutate-image-and-policy-webhook /k8s-mutate-image-and-policy-webhook
USER 65534
ENTRYPOINT ["/k8s-mutate-image-and-policy-webhook"]
EXPOSE 8443
