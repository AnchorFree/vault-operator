FROM golang:1.10-alpine

ENV DEP_VERSION=v0.4.1

RUN apk --no-cache add curl git bash
RUN curl -fsSL -o /usr/local/bin/dep https://github.com/golang/dep/releases/download/${DEP_VERSION}/dep-linux-amd64 \
 && chmod +x /usr/local/bin/dep

COPY . /go/src/github.com/coreos/vault-operator
RUN cd /go/src/github.com/coreos/vault-operator \
    && dep ensure -vendor-only \
    && ./hack/build \
    && mkdir /build/ && mv ./_output/bin/vault-operator /build/


FROM alpine

ENV BINARY vault-operator
COPY --from=0 /build/${BINARY} /usr/local/bin/${BINARY}

CMD ["vault-operator"]
