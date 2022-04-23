# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# This is NOT vanilla dwm but rather my personal build!!
EAPI=7

inherit savedconfig toolchain-funcs

DESCRIPTION="speedie's fork of dwm with .Xresources, pywal, alpha and config file support"
HOMEPAGE="https://speedie.gq"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/speedie-de/dwm"
else
	SRC_URI="https://raw.githubusercontent.com/speedie-de/dwm/tarball/dwm-spde-6.3.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="xinerama"

RDEPEND="
	media-libs/fontconfig
	x11-libs/libxcb
	x11-misc/xcb
	media-libs/imlib2
	x11-libs/libX11
	x11-libs/libXft
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	xinerama? ( x11-base/xorg-proto )
"

src_prepare() {
	default

	sed -i \
		-e "s/ -Os / /" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		-e "/^X11LIB/{s:/usr/X11R6/lib:/usr/$(get_libdir)/X11:}" \
		-e '/^X11INC/{s:/usr/X11R6/include:/usr/include/X11:}' \
		config.mk || die

	restore_config config.def.h
}

src_compile() {
	if use xinerama; then
		emake CC="$(tc-getCC)" dwm
	else
		emake CC="$(tc-getCC)" XINERAMAFLAGS="" XINERAMALIBS="" dwm
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	exeinto /etc/X11/Sessions
	#newexe "${FILESDIR}"/dwm-session2 dwm

	insinto /usr/share/xsessions
	#doins "${FILESDIR}"/dwm.desktop

	#dodoc README

	save_config config.def.h
}
