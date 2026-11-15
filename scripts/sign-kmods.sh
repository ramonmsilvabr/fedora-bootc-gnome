#!/usr/bin/bash

# Query kernel-core version installed
KERNEL_VERSION="$(rpm -q kernel-core --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
# File paths
PRIV_KEY="./pki/MOK.priv"
DER_CERT="./pki/MOK.der"
# Set permissions
chmod 444 $DER_CERT
chmod 400 $PRIV_KEY
# Temporarily install kernel-devel
dnf install -y kernel-devel 
# Sign file path
SIGN_FILE="/usr/src/kernels/${KERNEL_VERSION}/scripts/sign-file"
# Filter sign file existence
if [ ! -f "$SIGN_FILE" ]; then
    exit 1
fi
# Kmods location
TARGET_DIR="/usr/lib/modules/${KERNEL_VERSION}/extra/"
# Check compression and sign files
find "$TARGET_DIR" -type f \( -name "*.ko" -o -name "*.ko.xz" -o -name "*.ko.zst" \) | while read -r MODULE_PATH; do
    EXTENSION="${MODULE_PATH##*.}"
    RECOMPRESS=""
    CURRENT_FILE="$MODULE_PATH"
    if [ "$EXTENSION" == "xz" ]; then
        xz -d "$MODULE_PATH"
        CURRENT_FILE="${MODULE_PATH%.xz}"
        RECOMPRESS="xz"
    elif [ "$EXTENSION" == "zst" ]; then
        unzstd --rm "$MODULE_PATH"
        CURRENT_FILE="${MODULE_PATH%.zst}"
        RECOMPRESS="zstd"
    fi
    "$SIGN_FILE" sha256 "$PRIV_KEY" "$DER_CERT" "$CURRENT_FILE"
    if [ "$RECOMPRESS" == "xz" ]; then
        xz -f -C crc32 "$CURRENT_FILE"
    elif [ "$RECOMPRESS" == "zstd" ]; then
        zstd --rm -19 -f "$CURRENT_FILE"
    fi
done
# Remove files and packages correctly
rm -rfv "$PRIV_KEY" "$DER_CERT"
dnf remove -y kernel-devel 