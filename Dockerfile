FROM ubuntu
RUN apt-get update -qq

RUN apt-get install -y build-essential git
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install -y python python-setuptools python-dev python-tk python-pip
RUN pip install --upgrade pip
RUN pip install numpy scipy matplotlib notebook pandas sympy nose scikit-learn scikit-image h5py sureal

RUN git clone --depth 1 https://github.com/Netflix/vmaf.git vmaf
RUN cd vmaf/ptools && \
 make
RUN cd vmaf/wrapper && \
 make
RUN cd vmaf && \
 make install
RUN cd && \
apt-get update -qq && apt-get -y install \
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
RUN cd ~/ffmpeg_sources && \
wget https://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.bz2 && \
tar xjvf nasm-2.13.03.tar.bz2 && \
cd nasm-2.13.03 && \
./autogen.sh && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
make && \
make install
RUN cd
RUN apt-get install yasm
RUN apt-get install libx264-dev -y
RUN apt-get install libx265-dev libnuma-dev -y
RUN apt-get install libvpx-dev -y
RUN apt-get install libfdk-aac-dev -y
RUN apt-get install libmp3lame-dev -y
RUN apt-get install libopus-dev -y
RUN apt install ocl-icd-opencl-dev -y
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
  --enable-gnutls \
  --enable-nonfree && \
PATH="$HOME/bin:$PATH" make && \
make install && \
hash -r
RUN cd && \
cp bin/ffmpeg /usr/local/bin
