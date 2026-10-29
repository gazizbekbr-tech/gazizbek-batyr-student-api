# Docker-capable Jenkins build agent for Batyr Gazizbek: JDK 21 + Docker CLI + buildx
FROM docker:29-cli AS docker-cli
FROM docker/buildx-bin:0.38.1 AS buildx

FROM jenkins/inbound-agent:latest-jdk21
USER root
COPY --from=docker-cli /usr/local/bin/docker /usr/local/bin/docker
COPY --from=buildx /buildx /usr/local/lib/docker/cli-plugins/docker-buildx
USER jenkins
