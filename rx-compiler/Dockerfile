FROM ubuntu:16.04

LABEL maintainer=shinmi

ADD ./binutils-2.30.tar.gz /tmp/
ADD ./newlib-2.4.0.tar.gz /tmp/
ADD ./gcc-6.4.0.tar.gz /tmp/

RUN apt-get update \
    && apt-get install -y \
    texinfo \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    diffutils \
    automake \
    zlib1g-dev \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# binutils コンパイル
RUN cd /tmp/binutils-2.30/ \
    && mkdir rx_build \
    && cd rx_build \
    && ../configure \
    --target=rx-elf \
    --prefix=/usr/local/rx-elf \
    --disable-nls \
    && make \
    && make install

ENV PATH $PATH:/usr/local/rx-elf/bin

# gccコンパイル
RUN cd /tmp/gcc-6.4.0 \
    && mkdir rx_build \
    && cd rx_build \
    && ../configure \
    --prefix=/usr/local/rx-elf \
    --target=rx-elf \
    --enable-languages=c \
    --disable-libssp \
    --with-newlib \
    --disable-nls \
    --disable-threads \
    --disable-libgomp \
    --disable-libmudflap \
    --disable-libstdcxx-pch \
    --disable-multilib \
    --enable-lto \
    && make \
    && make install



# newlibのビルド
RUN cd /tmp/newlib-2.4.0 \
    && mkdir rx_build \
    && cd rx_build \
    && ../configure \
    --target=rx-elf \
    --prefix=/usr/local/rx-elf \
    && make \
    && make install

# c++コンパイラビルド
RUN cd /tmp/gcc-6.4.0/rx_build \
    && ../configure \
    --prefix=/usr/local/rx-elf \
    --target=rx-elf \
    --enable-languages=c,c++ \
    --disable-libssp \
    --with-newlib \
    --disable-nls \
    --disable-threads \
    --disable-libgomp \
    --disable-libmudflap \
    --disable-libstdcxx-pch \
    --disable-multilib \
    --enable-lto \
    --with-system-zlib \
    && make \
    && make install

# emacs インストール
RUN apt-get update && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:kelleyk/emacs && \
    apt-get update && \
    apt-get install -y \
    locales \
    emacs26 \
    git \
    emacs-mozc-bin && \
    locale-gen ja_JP.UTF-8 && \
    # 
    echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc

RUN useradd -G sudo -u 1000 --create-home emacs \
    && apt-get install -y \
    curl \
    gconf2

# emacs dbus エラー回避
ENV NO_AT_BRIDGE=1

RUN apt update && apt install -y --no-install-recommends \
    # git \
    # wget \
    build-essential \
    software-properties-common \
    libncurses5-dev \
    zlib1g-dev \
    # Install CMake
    && curl -O https://cmake.org/files/v3.15/cmake-3.15.4-Linux-x86_64.tar.gz \
    && tar xf cmake-3.15.4-Linux-x86_64.tar.gz \
    && rm cmake-3.15.4-Linux-x86_64.tar.gz \
    && ln -s /cmake-3.15.4-Linux-x86_64/bin/cmake /usr/bin/cmake \
    # Add llvm keys
    && /bin/bash -c 'echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main" >> /etc/apt/sources.list.d/llvm.list' \
    && /bin/bash -c 'echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main" >> /etc/apt/sources.list.d/llvm.list' \
    && curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    # Add gcc7 keys
    && add-apt-repository ppa:ubuntu-toolchain-r/test \
    # Install llvm and gcc7
    && apt-get update && apt-get install -y \
    g++-7 \
    libllvm7 \
    llvm-7 \
    llvm-7-dev \
    llvm-7-runtime \
    clang-7 \
    clang-tools-7 \
    libclang-common-7-dev \
    libclang-7-dev \
    libclang1-7 \
    clang-format-7 \
    python-clang-7 \
    lldb-7 \
    lld-7 \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7 \
    && update-alternatives --config gcc

ENV PATH /usr/lib/llvm-7/bin:$PATH

RUN cmake --help-module-list
RUN find /usr/ -name ClangConfig.cmake

# Install ccls
RUN git clone --depth=1 --recursive https://github.com/MaskRay/ccls \
    # curl -L https://github.com/MaskRay/ccls/archive/0.20190823.5.tar.gz | tar zx -C . \
    # && mv ccls-0.20190823.5 ccls \
    && cd ccls \
    && cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release \
    # && cmake -H. -BRelease -DCMAKE_CXX_COMPILER=/usr/lib/llvm-7/bin/clang++ -DSYSTEM_CLANG=ON \
    #                        -DCLANG_USE_BUNDLED_LIBC++=on -DCMAKE_PREFIX_PATH=/usr/lib/llvm-7/ \
    && cmake --build Release \
    && cd Release \
    && make install \
    && cd / && rm -rf ccls

# RUN git clone https://github.com/mzyy94/RictyDiminished-for-Powerline \
#     && ls -la \
#     && cd RictyDiminished-for-Powerline \
#     && cp *.ttf /usr/local/share/fonts/ \
#     && fc-cache -f \
#     && cd .. \
#     && rm -r RictyDiminished-for-Powerline

# ricty インストール
RUN apt-get update && apt-get install -y fontforge unzip
RUN curl -o /usr/local/share/fonts/Inconsolata-Regular.ttf -SL "https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Regular.ttf"  \
    && curl -o /usr/local/share/fonts/Inconsolata-Bold.ttf -SL "https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Bold.ttf"  \
    && curl -o migu.zip -SL "https://ja.osdn.net/frs/redir.php?m=jaist&f=mix-mplus-ipa%2F63545%2Fmigu-1m-20150712.zip" \
    && unzip migu.zip && rm migu.zip \
    && mv migu-1m-20150712/*.ttf /usr/local/share/fonts/ \
    && rm -r migu-1m-20150712 \
    && mkdir ricty \
    && cd ricty \
    && curl -o ricty_generator.sh https://rictyfonts.github.io/files/ricty_generator.sh \
    && sh ricty_generator.sh auto \
    && mv *.ttf /usr/local/share/fonts/ \
    && cd ../ \
    && rm -r ricty \
    && apt-get purge -y unzip fontforge


ENV HOME /home/emacs
WORKDIR /home/emacs
