#!/bin/bash -eu

tmp_dir="/tmp/kernel-src"

kernel_version_str=${1:-$(uname -r)}
kernel_version=$(echo "$kernel_version_str" | cut -d '-' -f1)  #ie 5.2.7
major_version=$(echo "$kernel_version" | cut -d '.' -f1)

set +e
if ! wget -c "https://cdn.kernel.org/pub/linux/kernel/v$major_version.x/linux-$kernel_version.tar.xz" -P "$tmp_dir"; then
        echo "kernel could not be downloaded...exiting" && exit
fi
set -e

tar --strip-components=2 -xf "$tmp_dir/linux-$kernel_version.tar.xz" --directory="$tmp_dir" "linux-$kernel_version/sound/hda"

cur_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
build_dir="$cur_dir/build"
build_hda_dir="$build_dir/hda"
patch_hda_dir="$cur_dir/hda"
kernel_hda_dir="$tmp_dir/hda"

# copy required files to $build_dir
mkdir -p "$build_hda_dir/codecs"
cp -rf "$kernel_hda_dir/common/" "$build_hda_dir"
cp -rf "$kernel_hda_dir/codecs/Makefile" "$build_hda_dir/codecs"
cp -rf "$kernel_hda_dir/codecs/cirrus" "$build_hda_dir/codecs"
cp -rf "$kernel_hda_dir/codecs/generic.h" "$build_hda_dir/codecs"
cp -rf "$kernel_hda_dir/codecs/generic.c" "$build_hda_dir/codecs"
cp -rf "$kernel_hda_dir/Makefile" "$build_hda_dir"

cp -rf "$patch_hda_dir" "$build_dir"

make KERNELRELEASE="$kernel_version_str"
sudo make install KERNELRELEASE="$kernel_version_str"
