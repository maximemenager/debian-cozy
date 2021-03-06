#!/bin/bash
set -xe
CHROOT_DIRECTORY="/usr/share/cozy/chroot"
DEBIAN_INCLUDE_PACKAGES="gnupg,apt-transport-https,ca-certificates,curl"
RELEASE="$(lsb_release -sc)"

mkdir -p "${CHROOT_DIRECTORY}"
debootstrap --variant=minbase --include="${DEBIAN_INCLUDE_PACKAGES}" \
	"${RELEASE}" "${CHROOT_DIRECTORY}"

chroot "${CHROOT_DIRECTORY}" /bin/bash <<EOF
	echo "deb https://deb.nodesource.com/node_8.x ${RELEASE} main" > "/etc/apt/sources.list.d/nodesource.list"
	curl -s "https://deb.nodesource.com/gpgkey/nodesource.gpg.key" | apt-key --keyring "/etc/apt/trusted.gpg.d/nodesource.gpg" add -
	apt update
	apt install -y nodejs
EOF
