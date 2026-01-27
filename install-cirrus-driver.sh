#!/bin/bash -eu

kernel_version_str=${1:-$(uname -r)}
kernel_version=$(echo "$kernel_version_str" | cut -d '-' -f1)  #ie 5.2.7
major_version=$(echo "$kernel_version" | cut -d '.' -f1)

make KERNELRELEASE="$kernel_version_str"
sudo make install KERNELRELEASE="$kernel_version_str"
