# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Customizable xsetroot bar designed to be used with window managers."
HOMEPAGE="https://speedie.gq/xshbar.html"
SRC_URI="https://raw.githubusercontent.com/speediegamer/xshbar/tarball/xshbar-0.1.tar.gz"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~riscv"

DEPEND="x11-apps/xsetroot"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
)

src_install() {
	cp -f "${S}/xshbar" "${D}/usr/bin"
	chmod +x "${D}/usr/bin"
}
