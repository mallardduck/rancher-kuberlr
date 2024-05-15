FROM --platform=$TARGETPLATFORM mallardduck/rancher-kuberlr:base-v0.4.5 as kuberlr
FROM --platform=$BUILDPLATFORM registry.suse.com/bci/bci-base:15.5 AS build

ARG TARGETPLATFORM
ARG TARGETARCH

RUN echo ${TARGETPLATFORM}
RUN echo ${TARGETARCH}

WORKDIR /tmp

# Define build arguments
ARG KUBECTL_VERSION_INFO

SHELL ["/bin/bash", "-c"]
RUN set -fx; versions=($KUBECTL_VERSION_INFO); \
    for i in "${!versions[@]}"; do \
        echo "The index is $i and the value is ${versions[$i]}"; \
        version=$(echo ${versions[$i]} | cut -d: -f1); \
        kubectl_url="https://dl.k8s.io/release/${version}/bin/linux/${TARGETARCH}/kubectl"; \
        kubectl_target="/usr/bin/kubectl${version:1}"; \
        echo "Downloading kubectl version ${version} from ${kubectl_url}"; \
        echo "Targeting ${kubectl_target}"; \
        curl -fsSL "$kubectl_url" -o "$kubectl_target"; \
        chmod 0755 "$kubectl_target"; \
    done

RUN ls -lah /usr/bin/kubectl*
RUN for f in $(ls /usr/bin/kubectl*);do echo $f; sha256sum $f; done

RUN set -fx; versions=($KUBECTL_VERSION_INFO); \
    for i in "${!versions[@]}"; do \
        version=$(echo ${versions[$i]} | cut -d: -f1); \
        arm64_sum=$(echo ${versions[$i]} | cut -d: -f2); \
        amd64_sum=$(echo ${versions[$i]} | cut -d: -f3); \
        s390x_sum=$(echo ${versions[$i]} | cut -d: -f4); \
        kubectl_target="/usr/bin/kubectl${version:1}"; \
        KUBE_SUM_NAME="${TARGETARCH}_sum"; \
        KUBE_SUM=${!KUBE_SUM_NAME}; \
        echo "${KUBE_SUM} ${kubectl_target}" | sha256sum -c -; \
    done

RUN mkdir -p /usr/etc; \
    touch /usr/etc/kuberlr.conf; \
    echo "AllowDownload = false" >> /usr/etc/kuberlr.conf; \
    echo 'SystemPath = "/usr/bin"' >> /usr/etc/kuberlr.conf; \
    echo "Timeout = 6" >> /usr/etc/kuberlr.conf;

FROM scratch
COPY --from=kuberlr /bin/kubectl /bin/kuberlr
COPY --from=kuberlr /bin/kubectl /bin/kubectl
COPY --from=kuberlr /etc/passwd /etc/passwd
COPY --from=kuberlr /etc/group /etc/group
COPY --from=build /usr/bin/kubectl* /usr/bin/
COPY --from=build /usr/etc/kuberlr.conf /usr/etc/kuberlr.conf

USER kuberlr
ENTRYPOINT ["/bin/kubectl"]
CMD ["help"]