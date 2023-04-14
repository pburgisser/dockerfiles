FROM google/cloud-sdk:426.0.0-slim
LABEL org.opencontainers.image.authors="pburgisser@gmail.com"

RUN ( \
  set -x; cd "$(mktemp -d)" && \
  OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
  KREW="krew-${OS}_${ARCH}" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
  tar zxvf "${KREW}.tar.gz" && \
  ./"${KREW}" install krew \
)

RUN apt update && \
    apt install kubectl && \
    apt-get install google-cloud-sdk-gke-gcloud-auth-plugin

ADD https://get.helm.sh/helm-v3.11.3-linux-amd64.tar.gz /tmp/helm.tar.gz
RUN tar zxvf /tmp/helm.tar.gz -C /tmp && \
    cp /tmp/linux-amd64/helm /usr/local/bin && \
    rm -rf /tmp/helm*

ENV PATH="/root/.krew/bin:$PATH"
RUN kubectl krew install neat ctx
WORKDIR /apps
