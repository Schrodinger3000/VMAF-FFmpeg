FROM ubuntu
RUN apt-get update -qq

RUN apt-get install -y build-essential git
ENV TZ=UTC


RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install -y python3 python3-pip python3-setuptools python3-wheel ninja-build doxygen nasm && pip3 install --user meson
RUN pip3 install --upgrade pip
RUN pip3 install numpy scipy matplotlib notebook pandas sympy nose scikit-learn scikit-image h5py sureal

RUN git clone --depth 1 https://github.com/Netflix/vmaf.git vmaf 

ENV PATH="${PATH}:/root/.local/bin"

RUN cd vmaf/libvmaf && meson build --buildtype release && ninja -vC build && ninja -vC build install

RUN cd && \
apt-get -y install \
autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  pkg-config \
  texinfo \
  wget \
  zlib1g-dev
RUN mkdir -p ~/ffmpeg_sources ~/bin

RUN cd
RUN apt-get install yasm
RUN apt-get install libx264-dev -y
RUN apt-get install libx265-dev libnuma-dev -y
RUN apt-get install libvpx-dev -y
RUN apt-get install libfdk-aac-dev -y
RUN apt-get install libmp3lame-dev -y
RUN apt-get install libopus-dev -y
RUN apt install ocl-icd-opencl-dev -y
RUN apt-get install libssl-dev -y
RUN cd ~/ffmpeg_sources && \
wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
tar xjvf ffmpeg-snapshot.tar.bz2 &&\
cd ffmpeg/ && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs="-lpthread -lm" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libvmaf \
  --enable-version3 \
  --enable-opencl \
  --enable-openssl \
  --enable-nonfree && \
PATH="$HOME/bin:$PATH" make -j4 && \
make -j4 install && \
hash -r
RUN cd && \
cp bin/ff* /usr/local/bin

WORKDIR /ffmpeg_working

ENTRYPOINT ["/usr/local/bin/ffmpeg"]
