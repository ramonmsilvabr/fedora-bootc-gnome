#!/bin/bash
# Variable that holds the kernel version
KERNEL_VERSION=$(cd /usr/lib/modules && echo *)
# Regenerate initramfs in the specified directory for this exact kernel version in verbose mode
dracut -vf /usr/lib/modules/$KERNEL_VERSION/initramfs.img $KERNEL_VERSION