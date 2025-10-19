FROM gitlab-registry.cern.ch/sft/docker/alma9:latest


# User and workdir settings:

USER root
WORKDIR /root


# Install yum/RPM packages:

RUN true \
    && sed -i '/tsflags=nodocs/d' /etc/yum.conf \
    && yum groupinstall -y \
        "Development Tools" \
    && yum install -y \
        wget curl rsync \
        p7zip \
        git svn \
        numactl \
        tmux \
    && true

    
# Install Julia:

COPY provisioning/install-julia.sh provisioning/

ENV \
    PATH="/opt/julia/bin:$PATH" \
    MANPATH="/opt/julia/share/man:$MANPATH" \
    JULIA_SSL_CA_ROOTS_PATH="/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem"

RUN provisioning/install-julia.sh 1.12.1 /opt/julia


# Set up unpacked directory:
COPY provisioning/unpacked/ /unpacked/
RUN true \
    chmod 644 /unpacked/*.sh /unpacked/image-name \
    chmod 755 /unpacked/bin/*


# Clean up:

RUN true \
    && yum clean all


# Default command:

CMD /bin/bash
