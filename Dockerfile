## Build Image
FROM ubuntu:24.04 AS build
# Install consul-template
ARG CONSUL_TEMPLATE_VERSION
# Pickup consul-template
ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS /tmp/
ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /tmp/

RUN apt-get update && apt-get install unzip && \
    cd /tmp && \
    sha256sum -c consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS 2>&1 | grep OK && \
    unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \
    mv consul-template /bin/consul-template

FROM cgr.dev/chainguard/static:latest

COPY --from=build --chown=65532:65532 --chmod=550 /bin/consul-template /bin/consul-template

ENTRYPOINT ["/bin/consul-template"]
