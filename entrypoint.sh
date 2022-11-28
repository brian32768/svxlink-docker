#!/bin/bash

# Force new UID if specified
#if [ -n "$SVXLINK_UID" ]; then
#  usermod -u $SVXLINK_UID svxlink
#fi

# Force new GID if specified
#if [ -n "$SVXLINK_GID" ]; then
#  usermod -g $SVXLINK_GID svxlink
#  find /home/svxlink ! -gid $SVXLINK_GID -exec chgrp $SVXLINK_GID {} \;
#fi

# Create the hostaudio group if GID is specified
if [ -n "$HOSTAUDIO_GID" ]; then
  groupadd -g $HOSTAUDIO_GID hostaudio
  usermod -G $HOSTAUDIO_GID svxlink
fi

# Set up the command line
CMD="svxlink "
#CMD+="PATH=$PATH:/usr/lib64/qt4/bin "
#CMD+="GIT_URL=$GIT_URL "
#CMD+="GIT_BRANCH=$GIT_BRANCH "
CMD+="NUM_CORES=$NUM_CORES "

echo The command is: $CMD

# If an argument is specified, run it as a command or else just start a shell
if [ $# -gt 0 ]; then
  exec $CMD "$@"
else
  exec $CMD -i
fi
