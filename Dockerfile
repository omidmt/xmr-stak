# Latest version of ubuntu
FROM nvidia/cuda:10.1-base

# Default git repository
ENV GIT_REPOSITORY https://github.com/omidmt/xmr-stak.git
ENV XMRSTAK_CMAKE_FLAGS -DXMR-STAK_COMPILE=generic -DCUDA_ENABLE=ON -DOpenCL_ENABLE=OFF -DCUDA_SHOW_REGISTER=ON

# Innstall packages
RUN apt-get update \
    && set -x \
    && apt-get install -qq --no-install-recommends -y build-essential ca-certificates cmake cuda-core-10-1 git cuda-cudart-dev-10-1 libhwloc-dev libmicrohttpd-dev libssl-dev cuda-nvrtc-dev-10-1 cuda-nvrtc-10-1 \
    && git clone $GIT_REPOSITORY \
    && cd /xmr-stak \
    && cmake ${XMRSTAK_CMAKE_FLAGS} . \
    && make \
    && cd - \
    && mv /xmr-stak/bin/* /usr/local/bin/ \
    && rm -rf /xmr-stak \
    && apt-get purge -y -qq build-essential cmake cuda-core-10-1 git cuda-cudart-dev-10-1 libhwloc-dev libmicrohttpd-dev libssl-dev \
    && apt-get clean -qq

VOLUME /mnt

WORKDIR /mnt

ENTRYPOINT ["/usr/local/bin/xmr-stak"]
