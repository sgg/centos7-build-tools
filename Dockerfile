from centos:7
MAINTAINER Shayan Mohanty "shayan@watchful.io"

RUN yum update -y && yum clean all && yum groupinstall -y 'Development Tools' && yum install -y git gcc make gcc-c++ which python2 libpcap bzip2-devel snappy-devel openssl-devel

ADD . /engine-src

# Install Ragel 6.9
WORKDIR /tmp/
RUN curl -O http://www.colm.net/files/ragel/ragel-6.9.tar.gz && tar -zxf ragel-6.9.tar.gz && cd ragel-6.9 && ./configure && make && make install
RUN rm -rf /tmp/ragel-6.9.tar.gz && rm -rf /tmp/ragel-6.9/

# Install cmake 3.9
WORKDIR /tmp/
RUN curl -O https://cmake.org/files/v3.11/cmake-3.11.0-rc2.tar.gz && tar xvfz cmake-3.11.0-rc2.tar.gz
WORKDIR /tmp/cmake-3.11.0-rc2/
RUN ./bootstrap && gmake && gmake install
RUN ln -s /usr/local/bin/cmake /usr/bin/cmake
RUN rm -rf /tmp/cmake-3.11.0-rc2.tar.gz && rm -rf /tmp/cmake-3.11.0-rc2/

# Install latest clang
WORKDIR /tmp/
RUN svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
WORKDIR /tmp/llvm/tools
RUN svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
WORKDIR /tmp/llvm/tools/clang/tools
RUN svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
WORKDIR /tmp/llvm/projects
RUN svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
WORKDIR /tmp/
RUN mkdir llvm.build
WORKDIR /tmp/llvm.build
RUN cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local ../llvm && make && make install
RUN rm -rf /tmp/llvm/
