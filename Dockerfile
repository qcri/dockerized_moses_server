FROM ubuntu:18.04
LABEL maintainer="Qatar Computing Research Institute - Arabic Language Technologies Group <ahammouda@hbku.edu.qa, Ahmed Abd Ali aabdelali@hbku.edu.qa>"

RUN apt-get update && apt-get install -q -y  git tar wget

# Install gcc 7
RUN apt update -qq \
&& apt install -yq software-properties-common \
&& add-apt-repository -y ppa:ubuntu-toolchain-r/test \
&& apt update -qq \
&& apt install -yq g++-7 \
&& apt clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Configure alias
RUN update-alternatives \
 --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 \
 --slave /usr/bin/g++ g++ /usr/bin/g++-7 \
 --slave /usr/bin/gcov gcov /usr/bin/gcov-7 \
 --slave /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-7 \
 --slave /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-7 \
 --slave /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-7 \
 --slave /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-7

WORKDIR /home/moses

RUN git clone https://github.com/moses-smt/mosesdecoder.git

RUN wget https://sourceforge.net/projects/xmlrpc-c/files/latest/download
RUN mv download xmlrpc-c-1.51.06.tgz

USER root
ADD sudoers.txt /etc/sudoers
RUN chmod 440 /etc/sudoers

RUN  tar -xvzf xmlrpc-c-1.51.06.tgz
RUN rm xmlrpc-c-1.51.06.tgz
WORKDIR /home/moses/xmlrpc-c-1.51.07/
RUN /home/moses/xmlrpc-c-1.51.07/configure

RUN apt-get update && apt-get install -y make cmake
RUN make
RUN make install

# #install boost
RUN  apt-get update && apt-get install -q -y build-essential  manpages-dev locales

WORKDIR /home/moses/
RUN wget http://sourceforge.net/projects/boost/files/boost/1.57.0/boost_1_57_0.tar.gz

RUN apt-get update && apt-get install -q -y g++  subversion automake libtool zlib1g-dev libicu-dev libboost-all-dev libbz2-dev liblzma-dev python-dev graphviz imagemagick  libgoogle-perftools-dev autoconf doxygen   update-manager-core

WORKDIR /home/moses
RUN tar  -xzf boost_1_57_0.tar.gz
RUN rm boost_1_57_0.tar.gz
WORKDIR /home/moses/boost_1_57_0
RUN /home/moses/boost_1_57_0/bootstrap.sh
RUN /home/moses/boost_1_57_0/b2 install
RUN apt-get update && apt-get install -q -y zlib1g-dev libicu-dev libboost-all-dev libbz2-dev liblzma-dev
RUN /home/moses/boost_1_57_0/b2 -j8

# install cmph-2.0.2
WORKDIR /home/moses
RUN wget https://sourceforge.net/projects/cmph/files/v2.0.2/cmph-2.0.2.tar.gz
RUN tar -xvzf cmph-2.0.2.tar.gz
RUN rm cmph-2.0.2.tar.gz
WORKDIR /home/moses/cmph-2.0.2/
RUN /home/moses/cmph-2.0.2/configure
RUN make
RUN make install /usr/local/bin/

WORKDIR /home/moses/mosesdecoder/
RUN /home/moses/mosesdecoder/bjam --with-boost=/home/moses/boost_1_57_0/ --with-cmph=/usr/local/ --with-xmlrpc-c=/usr/local/ -j12

ENV LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
