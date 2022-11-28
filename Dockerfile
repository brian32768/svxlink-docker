FROM debian:11
MAINTAINER Tobias Blomberg <sm0svx@ssa.se>

# Install required packages and set up the svxlink user
RUN apt-get update && \
    apt-get -y install git cmake g++ make libsigc++-2.0-dev libgsm1-dev \
                       libpopt-dev tcl8.6-dev libgcrypt20-dev libspeex-dev \
                       libasound2-dev \
                       libopus-dev librtlsdr-dev libcurl4-openssl-dev
# Should be in the SECOND STAGE
RUN apt-get -y install alsa-utils vorbis-tools curl sudo screen
#RUN apt-get -y install groff doxygen

# Install svxlink audio files
RUN mkdir -p /usr/share/svxlink/sounds && \
    cd /usr/share/svxlink/sounds && \
    curl -LO https://github.com/sm0svx/svxlink-sounds-en_US-heather/releases/download/14.08/svxlink-sounds-en_US-heather-16k-13.12.tar.bz2 && \
    tar xvaf svxlink-sounds-* && \
    ln -s en_US-heather-16k en_US && \
    rm svxlink-sounds-*

# Set up password less sudo for user svxlink
ADD sudoers-svxlink /etc/sudoers.d/svxlink
RUN chmod 0440 /etc/sudoers.d/svxlink

RUN useradd -s /bin/bash svxlink

WORKDIR /home/svxlink
RUN git clone https://github.com/sm0svx/svxlink.git
ADD build-svxlink.sh /home/svxlink/
RUN NUM_CORES=4 /home/svxlink/build-svxlink.sh

EXPOSE 5198
EXPOSE 5199
EXPOSE 5200

ADD entrypoint.sh /
#ENTRYPOINT ["/entrypoint.sh"]

CMD screen -dmS "svxlink" svxlink && screen -x svxlink
