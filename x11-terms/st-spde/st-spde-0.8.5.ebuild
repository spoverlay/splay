# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# This is not a vanilla build of st. This is my personal build of st.
EAPI=7

inherit desktop savedconfig toolchain-funcs

DESCRIPTION="Fork of st with .Xresources+pywal, alpha, copyout, colored fonts and more"
HOMEPAGE="https://speedie.gq"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/speedie-de/st"
else
	SRC_URI="https://raw.githubusercontent.com/speedie-de/st/tarball/st-spde-0.8.5.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~ppc64 ~riscv ~x86"
fi

LICENSE="MIT-with-advertising"
SLOT="0"

RDEPEND="
	>=sys-libs/ncurses-6.0:0=
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXft
	~x11-terms/st-terminfo-${PV}
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -i \
		-e "/^X11LIB/{s:/usr/X11R6/lib:/usr/$(get_libdir)/X11:}" \
		-e '/^STLDFLAGS/s|= .*|= $(LDFLAGS) $(LIBS)|g' \
		-e '/^X11INC/{s:/usr/X11R6/include:/usr/include/X11:}' \
		config.mk || die
	sed -i \
		-e '/tic/d' \
		Makefile || die

	restore_config config.def.h
}

src_configure() {
	sed -i \
		-e "s|pkg-config|$(tc-getPKG_CONFIG)|g" \
		config.mk || die

	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install

	#dodoc TODO

	make_desktop_entry ${PN} simpleterm utilities-terminal 'System;TerminalEmulator;' ''

	save_config config.def.h
}

pkg_postinst() {
	if ! [[ "${REPLACING_VERSIONS}" ]]; then
		elog "Please ensure a usable font is installed, like"
		elog "    media-fonts/corefonts"
		elog "    media-fonts/dejavu"
		elog "    media-fonts/urw-fonts"
	fi
}
