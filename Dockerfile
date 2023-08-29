FROM craftech/aws-cli:latest_alpine AS ct-aws-cli
FROM alpine:3.16

WORKDIR /helm

ADD https://get.helm.sh/helm-v3.10.3-linux-amd64.tar.gz helm.tar.gz

COPY --from=ct-aws-cli /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=ct-aws-cli /aws-cli-bin/ /usr/local/bin/

RUN apk add --no-cache \
        jq \
        git \
        bash \
        curl \
        grep \
        tar && \
    tar -zxvf helm.tar.gz && mv linux-amd64/helm /usr/local/bin/helm && \
    chown -R 999 /helm

USER 999

ENV HELM_CONFIG_HOME=/helm
ENV HELM_CACHE_HOME=/helm 
ENV HELM_DATA_HOME=/helm
