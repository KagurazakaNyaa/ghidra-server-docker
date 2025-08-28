FROM alpine:3 AS downloader
ARG GHIDRA_RELEASE_URL=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.4.2_build/ghidra_11.4.2_PUBLIC_20250826.zip
ARG GHIDRA_VERSION=Ghidra_11.4.2_build
RUN apk add --no-cache curl wget unzip
RUN curl -L ${GHIDRA_RELEASE_URL} -o /tmp/ghidra_release.zip
RUN unzip /tmp/ghidra_release.zip -d /tmp
RUN mv /tmp/$(echo "$GHIDRA_VERSION" | tr '[:upper:]' '[:lower:]' | sed -e 's/build/PUBLIC/g') /tmp/ghidra_release

FROM eclipse-temurin:21
COPY --from=downloader /tmp/ghidra_release /opt/ghidra
EXPOSE 13100-13102/tcp
VOLUME [ "/opt/ghidra/repositories" ]
WORKDIR /opt/ghidra
ENTRYPOINT ["/bin/bash"]
CMD [ "/opt/ghidra/server/ghidraSvr", "console", "-autoProvision", "-u"]