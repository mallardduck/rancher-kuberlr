ARG BCI_VERSION=15.5
FROM registry.suse.com/bci/bci-busybox:${BCI_VERSION} as final
FROM --platform=$TARGETPLATFORM mallardduck/rancher-kuberlr:base-v0.4.5 as kuberlr
FROM --platform=$BUILDPLATFORM registry.suse.com/bci/bci-base:${BCI_VERSION} AS build

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

FROM registry.suse.com/bci/bci-base:${BCI_VERSION} as zypper
# Creates the based dir for the target image, and hydrades it with the
# original contents of the final image.
RUN mkdir /chroot
COPY --from=final / /chroot/


# The final image does not contain zypper, --installroot is used to
# install all artefacts within a dir (/chroot) that can then be copied
# over to a scratch image.
RUN zypper --non-interactive refresh && \
    zypper --installroot /chroot -n rm busybox-vi busybox-links && \
    zypper --installroot /chroot -n in bash-completion jq vim curl && \
    zypper --installroot /chroot clean -a && \
    rm -rf /chroot/var/cache/zypp/* /chroot/var/log/zypp/* /chroot/etc/zypp/


RUN echo 'kuberlr:x:1000:1000:kuberlr,,,:/home/kuberlr:/bin/bash' > /chroot/etc/passwd && \
    echo 'kuberlr:x:1000:' > /chroot/etc/group && \
    mkdir /chroot/home/kuberlr && \
    echo '. /etc/profile.d/bash_completion.sh' >> /chroot/home/kuberlr/.bashrc && \
    echo 'alias k="kubectl"' >> /chroot/home/kuberlr/.bashrc && \
    echo 'alias ks="kubectl -n kube-system"' >> /chroot/home/kuberlr/.bashrc && \
    echo 'source <(kuberlr completion bash)' >> /chroot/home/kuberlr/.bashrc && \
    echo 'source <(kubectl completion bash)' >> /chroot/home/kuberlr/.bashrc && \
    echo 'complete -o default -F __start_kubectl k' >> /chroot/home/kuberlr/.bashrc && \
    echo 'LANG=en_US.UTF-8' >> /chroot/home/kuberlr/.bashrc && \
    echo 'PS1="> "' >> /chroot/home/kuberlr/.bashrc && \
    mkdir /chroot/home/kuberlr/.kube && \
    mkdir /chroot/home/kuberlr/.kuberlr && \
    touch /chroot/home/kuberlr/.kuberlr/kuberlr.conf && \
    echo "AllowDownload = false" >> /chroot/home/kuberlr/.kuberlr/kuberlr.conf && \
    echo 'SystemPath = "/usr/bin"' >> /chroot/home/kuberlr/.kuberlr/kuberlr.conf && \
    echo "Timeout = 6" >> /chroot/home/kuberlr/.kuberlr/kuberlr.conf && \
    chown -R 1000:1000 /chroot/home/kuberlr && \
    chmod 700 /chroot/run


FROM scratch

COPY --from=zypper /chroot /
COPY --from=kuberlr /bin/kuberlr /bin/kuberlr
RUN ln -s /bin/kuberlr /bin/kubectl
COPY --from=build /usr/bin/kubectl* /usr/bin/

USER kuberlr
WORKDIR /home/kuberlr
ENTRYPOINT ["/bin/kubectl"]
CMD ["help"]