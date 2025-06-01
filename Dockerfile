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
    PATH="/opt/julia/bin:/opt/julia-1.12/bin:/opt/julia-1.11/bin:$PATH" \
    MANPATH="/opt/julia/share/man:$MANPATH" \
    JULIA_SSL_CA_ROOTS_PATH="/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem"

RUN true\
    && mkdir /opt/julia-local \
    && provisioning/install-julia.sh 1.11.5 /opt/julia-1.11 \
    && (cd /opt/julia-1.11 && ln -s ../julia-local local) \
    && (cd /opt/julia-1.11/bin && ln -s julia julia-1.11) \
    && provisioning/install-julia.sh 1.12.0-beta3 /opt/julia-1.12 \
    && (cd /opt/julia-1.12 && ln -s ../julia-local local) \
    && (cd /opt/julia-1.12/bin && ln -s julia julia-1.12) \
    && (cd /opt && ln -s julia-1.11 julia)


# Clean up:

RUN true \
    && yum clean all


# Default command:

CMD /bin/bash
