#!/usr/bin/bash

# Variable that holds the kernel version based in rpm format
KERNEL_VERSION="$(rpm -q kernel-core --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
# Variables that hold the directory of the MOK certificate and MOK private key
PRIV_KEY="./MOK.priv"
DER_CERT="./MOK.der"

# Changes permissions for security context
chmod 444 $DER_CERT
chmod 400 $PRIV_KEY

# Temporalily install kernel-devel
dnf install -y kernel-devel 

# The kernel signs based in the script from kernel source
SIGN_FILE="/usr/src/kernels/${KERNEL_VERSION}/scripts/sign-file"

# If the kernel signature utility exists procced, otherwise exit
if [ ! -f "$SIGN_FILE" ]; then
    exit 1
fi

# Directory that has the out-of-tree modules to sign
TARGET_DIR="/usr/lib/modules/${KERNEL_VERSION}/extra/"

# This part checks all the modules present at runtime and signs them
find "$TARGET_DIR" -type f \( -name "*.ko" -o -name "*.ko.xz" -o -name "*.ko.zst" \) | while read -r MODULE_PATH; do
    EXTENSION="${MODULE_PATH##*.}"
    RECOMPRESS=""
    CURRENT_FILE="$MODULE_PATH"
    # This part decompress the file and marks which type has been used
    if [ "$EXTENSION" == "xz" ]; then
        xz -d "$MODULE_PATH"
        CURRENT_FILE="${MODULE_PATH%.xz}"
        RECOMPRESS="xz"
    elif [ "$EXTENSION" == "zst" ]; then
        unzstd --rm "$MODULE_PATH"
        CURRENT_FILE="${MODULE_PATH%.zst}"
        RECOMPRESS="zstd"
    fi
    # This is the exact sign process that uses it
    "$SIGN_FILE" sha256 "$PRIV_KEY" "$DER_CERT" "$CURRENT_FILE"
    echo "${SIGN_FILE} has been signed for Secure Boot"
    # Then this part recompress it based in the mark left before
    if [ "$RECOMPRESS" == "xz" ]; then
        xz -f -C crc32 "$CURRENT_FILE"
    elif [ "$RECOMPRESS" == "zstd" ]; then
        zstd --rm -19 -f "$CURRENT_FILE"
    fi
done

# This cleanup deletes the private key and certificate entirely after execution
rm -rfv "$PRIV_KEY" "$DER_CERT"

# This removes the temporarily installed kernel-devel package
dnf remove -y kernel-devel 