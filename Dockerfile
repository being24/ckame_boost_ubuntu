
FROM ubuntu:22.04

WORKDIR /work/

ENV LC_CTYPE='C.UTF-8'
ENV LC_ALL='C.UTF-8'
ENV DEBIAN_FRONTEND=noninteractive

RUN set -x && \
    apt-get update && apt-get install -y && \
    apt-get install wget curl git build-essential libssl-dev cmake nano -y && \
    curl https://getmic.ro | bash && \
    mv micro /usr/bin && \
    wget https://boostorg.jfrog.io/artifactory/main/release/1.82.0/source/boost_1_82_0.tar.bz2 && \
    tar -xf ./boost_1_82_0.tar.bz2 && \
    rm -rf ./boost_1_82_0.tar.bz2 && \
    cd ./boost_1_82_0 && \
    sh ./bootstrap.sh && \
    ./b2 install -j2 -j $(grep cpu.cores /proc/cpuinfo | sort -u | awk '{split($0, ary, ": "); print(ary[2] + 1)}' ) && \
    cd /work && \
    rm -rf boost_1_82_0

CMD ["/bin/bash"]

