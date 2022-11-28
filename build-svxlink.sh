#!/bin/bash -xe

# Find out how many cores we've got
num_cores=${NUM_CORES:-1}

# Create a build directory and build svxlink

[[ -d build ]] && rm -rf build
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_SYSCONFDIR=/etc \
      -DCMAKE_INSTALL_LOCALSTATEDIR=/var \
      -DCMAKE_BUILD_TYPE=Release ../svxlink/src
make -j$num_cores
sudo make install
sudo ldconfig
