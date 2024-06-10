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

FROM registry.suse.com/bci/bci-base:15.5 as final
RUN zypper -n update && \
    zypper -n install bash-completion gzip jq tar unzip vim wget && \
    zypper clean -a && rm -rf /tmp/* /var/tmp/* /usr/share/doc/packages/* /usr/share/doc/manual/* /var/log/*
RUN echo 'kuberlr:x:1000:1000:kuberlr,,,:/home/kuberlr:/bin/bash' > /etc/passwd && \
    echo 'kuberlr:x:1000:' > /etc/group && \
    mkdir /home/kuberlr && \
    echo '. /etc/profile.d/bash_completion.sh' >> /home/kuberlr/.bashrc && \
    echo 'alias k="kubectl"' >> /home/kuberlr/.bashrc && \
    echo 'alias ks="kubectl -n kube-system"' >> /home/kuberlr/.bashrc && \
    echo 'source <(kuberlr completion bash)' >> /home/kuberlr/.bashrc && \
    echo 'source <(kubectl completion bash)' >> /home/kuberlr/.bashrc && \
    echo 'complete -o default -F __start_kubectl k' >> /home/kuberlr/.bashrc && \
    echo 'LANG=en_US.UTF-8' >> /home/kuberlr/.bashrc && \
    echo 'PS1="> "' >> /home/kuberlr/.bashrc && \
    mkdir /home/kuberlr/.kube && \
    mkdir /home/kuberlr/.kuberlr && \
    touch /home/kuberlr/.kuberlr/kuberlr.conf && \
    echo "AllowDownload = false" >> /home/kuberlr/.kuberlr/kuberlr.conf && \
    echo 'SystemPath = "/usr/bin"' >> /home/kuberlr/.kuberlr/kuberlr.conf && \
    echo "Timeout = 6" >> /home/kuberlr/.kuberlr/kuberlr.conf && \
    chown -R kuberlr /home/kuberlr && \
    chmod 700 /run


COPY --from=kuberlr /bin/kuberlr /bin/kuberlr
RUN ln -s /bin/kuberlr /bin/kubectl
COPY --from=build /usr/bin/kubectl* /usr/bin/

USER kuberlr
WORKDIR /home/kuberlr
ENTRYPOINT ["/bin/kubectl"]
CMD ["help"]