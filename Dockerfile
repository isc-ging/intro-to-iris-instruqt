FROM intersystems/iris-community:latest-em

USER root

# Layer: system packages
RUN apt-get update && apt-get install -y curl git && rm -rf /var/lib/apt/lists/*

# Layer: mailpit binary
ARG MAILPIT_VERSION=v1.27.7
RUN ARCH="$(uname -m)" && \
    case "$ARCH" in \
        x86_64) FILE="mailpit-linux-amd64.tar.gz" ;; \
        aarch64|arm64) FILE="mailpit-linux-arm64.tar.gz" ;; \
        *) echo "Unsupported architecture: $ARCH"; exit 1 ;; \
    esac && \
    curl -fsSL "https://github.com/axllent/mailpit/releases/download/${MAILPIT_VERSION}/${FILE}" \
        -o /tmp/mailpit.tar.gz && \
    tar -xzf /tmp/mailpit.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/mailpit && \
    rm /tmp/mailpit.tar.gz

COPY --chown=irisowner:irisowner . /home/irisowner/intro-to-iris-instruqt/

# Layer: IRIS setup — start IRIS, run challenge 1 + 2 setup, stop IRIS
# Challenge 2 setup skips mailpit install (already in PATH) but still runs the iris session steps

USER irisowner
RUN iris start IRIS && \
    iris stop IRIS quietly

