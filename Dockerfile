FROM debian:11
LABEL MAINTAINER="brian@wildsong.biz"

# Install required packages and set up the svxlink user
RUN apt-get update && \
    apt-get -y install \
        g++ cmake make libsigc++-2.0-dev libgsm1-dev libpopt-dev tcl-dev libgcrypt20-dev \
        libspeex-dev libasound2-dev libopus-dev librtlsdr-dev vorbis-tools curl libcurl4-openssl-dev \
        git rtl-sdr libcurl4-openssl-dev cmake libjsoncpp-dev

# Should be in the SECOND STAGE
RUN apt-get -y install alsa-utils vorbis-tools curl
#RUN apt-get -y install groff doxygen # We don't need to build docs here

WORKDIR /home/svxlink
RUN git clone https://github.com/sm0svx/svxlink.git

WORKDIR /home/svxlink/svxlink/src/build
RUN cmake -DUSE_QT=OFF -DCMAKE_INSTALL_PREFIX=/usr -DSYSCONF_INSTALL_DIR=/etc -DLOCAL_STATE_DIR=/var -DWITH_SYSTEMD=ON ..
RUN make -j3

# The 'make install' will do a chown so we need the user before doing the installation.
# The gpio group does not exist in the generic Docker --- hmmm can't do that bit
# Never worked with a GPIO before, so hopefully I can use it in a Docker.
RUN useradd -s /bin/bash -rG audio,plugdev,dialout svxlink
#RUN useradd -s /bin/bash -rG audio,plugdev,gpio,dialout svxlink
RUN make  install

EXPOSE 5198
EXPOSE 5199
EXPOSE 5200

# Install audio files
WORKDIR /usr/share/svxlink/sounds
RUN curl -LO https://github.com/sm0svx/svxlink-sounds-en_US-heather/releases/download/19.09/svxlink-sounds-en_US-heather-16k-19.09.tar.bz2

RUN tar xvjf svxlink-sounds-en_US-heather-16k-19.09.tar.bz2 && \
    ln -s en_US-heather-16k en_US
    
WORKDIR /home/svxlink
ADD entrypoint.sh .

ENTRYPOINT ["/home/svxlink/entrypoint.sh"]

#CMD screen -dmS "svxlink" svxlink && screen -x svxlink
