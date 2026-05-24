#!/bin/bash -eu

os_release_file="/etc/os-release"

kernel_version_str="${1:-$(ls -1 /lib/modules/ | sort -n -r | head -n 1)}"

version_delim=""

if [[ -f "$os_release_file" ]]; then
	. "$os_release_file"
	case "$ID" in
		arch)
			version_delim='-'
			;;
		debian)
			version_delim='+'
			;;
		*)
			echo "Unknown system $ID"
			exit 1
			;;
	esac
else
	echo "Cannot determine OS type"
	exit 1
fi

kernel_version=$(echo "$kernel_version_str" | cut -d "$version_delim" -f1)  #ie 5.2.7
major_version=$(echo "$kernel_version" | cut -d '.' -f1)

make KERNELRELEASE="$kernel_version_str"
sudo make install KERNELRELEASE="$kernel_version_str"
