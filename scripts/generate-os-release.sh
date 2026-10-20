#!/bin/bash

set -eu;
FILE=/usr/lib/os-release;
FULL_VERSION="${FEDORA_VERSION}.${IMAGE_VERSION}";
sed -i '/^OSTREE_VERSION=/d;/^BUILD_ID=/d;/^IMAGE_VERSION=/d' $FILE;
sed -i "s|^VERSION=.*|VERSION=\"${FULL_VERSION} (GNOME) - por @ramonmsilvabr\"|" $FILE; 
sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"Fedora Linux ${FEDORA_VERSION}.${IMAGE_VERSION} (GNOME) - por @ramonmsilvabr\"|" $FILE;
sed -i "s|^NAME=.*|NAME=\"Fedora Linux (GNOME) - por @ramonmsilvabr\"|" $FILE;
printf "OSTREE_VERSION='%s'\nBUILD_ID=\"%s\"\nIMAGE_VERSION=\"%s\"\n" "$FULL_VERSION" "$FULL_VERSION" "$FULL_VERSION" >> $FILE