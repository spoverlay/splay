# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Minimal rautafarmi client with Vim keybinds."
HOMEPAGE="https://github.com/speediegamer/rchat"
SRC_URI="https://raw.githubusercontent.com/speediegamer/rchat/tarball/rchat-0.4.tar.gz"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~~riscv ~x86"

DEPEND="
	app-shells/bash
	sys-apps/sed
	net-misc/curl
"

RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	cp -f "${S}/rchat" "${D}/usr/bin"
	chmod +x "${D}/usr/bin"
}
