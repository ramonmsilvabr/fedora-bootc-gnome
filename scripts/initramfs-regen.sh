#!/bin/bash
KERNEL_VERSION=$(cd /usr/lib/modules && echo *)
dracut -vf /usr/lib/modules/$KERNEL_VERSION/initramfs.img $KERNEL_VERSION