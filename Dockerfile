
FROM ubuntu

WORKDIR /work/

ENV LC_CTYPE='C.UTF-8'
ENV DEBIAN_FRONTEND=noninteractive

RUN set -x && \ 
    apt-get update && apt-get install -y && \
    apt-get install wget curl git build-essential libssl-dev -y && \
    curl https://getmic.ro | bash && \
    mv micro /usr/bin && \
    wget https://sourceforge.net/projects/boost/files/boost/1.77.0/boost_1_77_0.tar.gz && \
    tar -xf ./boost_1_77_0.tar.gz && \
    mv ./boost_1_77_0 /opt/ && \
    rm -rf ./work/boost_1_77_0.tar.gz && \
    cd /opt/boost_1_77_0 && \
    sh ./bootstrap.sh && \
    ./b2 install -j2 -j $(grep cpu.cores /proc/cpuinfo | sort -u | awk '{split($0, ary, ": "); print(ary[2] + 1)}' ) && \
    export BOOST_ROOT="/opt/boost_1_77_0" && \ 
    cd /work && \ 
    wget https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3.tar.gz && \
    tar xvf cmake-3.21.3.tar.gz && \ 
    cd cmake-3.21.3 && \
    ./configure && \ 
    make && \
    make install && \ 
    export PATH="/usr/local/bin:$PATH" && \
    rm -rf /work/cmake-3.21.3 && \ 
    rm -rf /work/boost_1_77_0.tar.gz && \
    rm -rf /work/cmake-3.21.3.tar.gz

CMD ["/bin/bash"]

