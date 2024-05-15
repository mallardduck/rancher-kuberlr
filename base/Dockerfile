FROM registry.suse.com/bci/bci-base:15.5 AS build

ARG TARGETPLATFORM
ARG KUBERLR_RELEASE

WORKDIR /tmp
RUN set -x \
 && export ARCHIVE_NAME="kuberlr_${KUBERLR_RELEASE:1}_linux_amd64" \
 && curl -fsSLO https://github.com/flavio/kuberlr/releases/download/${KUBERLR_RELEASE}/${ARCHIVE_NAME}.tar.gz \
 && tar -xvzf ${ARCHIVE_NAME}.tar.gz \
 && chmod +x ${ARCHIVE_NAME}/kuberlr \
 && mv ${ARCHIVE_NAME}/kuberlr /bin/kuberlr
RUN useradd -u 1000 -U -m kuberlr
RUN ln -s /bin/kuberlr /bin/kubectl

FROM scratch
COPY --from=build /bin/kubectl /bin/kuberlr
RUN ln -s /bin/kuberlr /bin/kubectl
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group
USER kuberlr
ENTRYPOINT ["/bin/kuberlr"]
CMD ["help"]