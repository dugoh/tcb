XORG_CONFIG := --sysconfdir=/etc --localstatedir=/var --disable-static

# -------------------
xcb-proto_VERSION = -1.11
bigreqsproto_VERSION = -1.1.2
compositeproto_VERSION = -0.4.2
damageproto_VERSION = -1.2.1
dmxproto_VERSION = -2.3.1
dri2proto_VERSION = -2.8
dri3proto_VERSION = -1.0
fixesproto_VERSION = -5.0
fontsproto_VERSION = -2.1.3
glproto_VERSION = -1.4.17
inputproto_VERSION = -2.3.1
kbproto_VERSION = -1.0.6
presentproto_VERSION = -1.0
randrproto_VERSION = -1.4.0
recordproto_VERSION = -1.14.2
renderproto_VERSION = -0.11.1
resourceproto_VERSION = -1.2.0
scrnsaverproto_VERSION = -1.2.2
videoproto_VERSION = -2.3.2
xcmiscproto_VERSION = -1.2.2
xextproto_VERSION = -7.3.0
xf86bigfontproto_VERSION = -1.2.0
xf86dgaproto_VERSION = -2.1
xf86driproto_VERSION = -2.1.1
xf86vidmodeproto_VERSION = -2.3.1
xineramaproto_VERSION = -1.2.1
xproto_VERSION = -7.0.26

PROTO_XLIBS = bigreqsproto compositeproto damageproto dmxproto dri2proto dri3proto fixesproto fontsproto 	\
glproto inputproto kbproto presentproto randrproto recordproto renderproto resourceproto scrnsaverproto videoproto \
xcmiscproto xextproto			\
xf86bigfontproto xf86dgaproto xf86driproto xf86vidmodeproto xineramaproto xproto
xprotoheaders: $(PROTO_XLIBS)

# -------------------

xtrans_VERSION = -1.3.4
libX11_VERSION = -1.6.2
libXext_VERSION = -1.3.3
libXext_EXTRA_CONFIG = --enable-malloc0returnsnull
libFS_VERSION = -1.0.6
libFS_EXTRA_CONFIG = --enable-malloc0returnsnull
libICE_VERSION = -1.0.9
libSM_VERSION = -1.2.2
libXScrnSaver_VERSION = -1.2.2
libXt_VERSION = -1.1.4
libXt_EXTRA_CONFIG = --with-appdefaultdir=/etc/X11/app-defaults
libXmu_VERSION = -1.1.2
libXpm_VERSION = -3.5.11
libXaw_VERSION = -1.0.12
libXfixes_VERSION = -5.0.1
libXcomposite_VERSION = -0.4.4
libXrender_VERSION = -0.9.8
libXcursor_VERSION = -1.1.14
libXdamage_VERSION = -1.1.4
libfontenc_VERSION = -1.1.2
libXfont_VERSION = -1.5.0
libXfont_EXTRA_CONFIG = --disable-devel-docs
libXft_VERSION = -2.3.2
libXi_VERSION = -1.7.4
libXrandr_VERSION = -1.4.2
libXinerama_VERSION = -1.1.3
libXres_VERSION = -1.0.7
libXtst_VERSION = -1.2.2
libXv_VERSION = -1.0.10
libXvMC_VERSION = -1.0.8
libXxf86dga_VERSION = -1.1.4
libXxf86vm_VERSION = -1.1.3
libdmx_VERSION = -1.1.3
libpciaccess_VERSION = -0.13.2
libxkbfile_VERSION = -1.0.8
libxshmfence_VERSION = -1.1
xkeyboard-config_VERSION = -2.9
xkeyboard-config_EXTRA_CONFIG = --disable-nls --with-xkb-rules-symlink=xorg
xcursor-themes_VERSION = -1.0.4

glu_VERSION = -9.0.0
freeglut_VERSION = -2.8.1
glew_VERSION = -1.10.0

XLIBS2 = xtrans libX11 libXext libFS libICE libSM libXScrnSaver libXt libXmu libXpm libXaw libXfixes \
libXcomposite libXrender libXcursor libXdamage libfontenc libXfont libXft libXi libXinerama libXrandr \
libXres libXtst libXv libXvMC libXxf86dga libXxf86vm libdmx libxkbfile libxshmfence \
xcb-util \
xbitmaps \
xkeyboard-config

#xcursor-themes \


xlibs2: $(XLIBS2) libpciaccess

# -------------------

libpng_VERSION = -1.6.2
libjpeg-turbo_VERSION = -1.2.1
libjpeg-turbo_EXTRA_CONFIG = --with-jpeg8
pixman_VERSION = -0.30.2
pixman_EXTRA_CONFIG = --disable-openmp --disable-gtk
#pixman_EXTRA_CFLAGS = -DPIXMAN_NO_TLS
freetype_VERSION = -2.5.0.1

# -------------------

font-util_VERSION = -1.3.0
encodings_VERSION = -1.0.4
font-bh-75dpi_VERSION = -1.0.3
font-bh-ttf_VERSION = -1.0.3
font-adobe-75dpi_VERSION = -1.0.3
XFONTS = font-util encodings 
xfonts: $(XFONTS) font-bh-75dpi font-bh-ttf font-adobe-75dpi

# -------------------

util-macros_VERSION = -1.17.1
libXau_VERSION = -1.0.8
fontconfig_VERSION = -2.11.1
fontconfig_EXTRA_CONFIG = --disable-docs --sysconfdir=/etc --localstatedir=/var
libXdmcp_VERSION = -1.1.1
xbitmaps_VERSION = -1.1.1
libxcb_VERSION = -1.11
libxcb_EXTRA_CONFIG = --disable-build-docs
xcb-util_VERSION = -0.3.9
XLIBS = util-macros libXau libXdmcp xcb-proto
xlibs: $(XLIBS) libxcb

# -------------------

twm_VERSION = -1.0.7
xcalc_VERSION = -1.0.5
xmodmap_VERSION = -1.0.8
xeyes_VERSION = -1.1.1
xclock_VERSION = -1.0.6
xbomb_VERSION = -2.2a
xinit_VERSION = -1.3.2
xinit_EXTRA_CONFIG = --with-xinitdir=/etc/X11/app-defaults
xkbcomp_VERSION = -1.2.4
xsetroot_VERSION = -1.1.1
xscreensaver_VERSION = -5.29
XAPPS = twm xeyes xclock xcalc xmodmap xinit xkbcomp xauth xset xsetroot xdpyinfo xscreensaver
xauth_VERSION = -1.0.7
xset_VERSION = -1.2.2
xdpyinfo_VERSION = -1.3.1
xapps: $(XAPPS) xterm xbomb



# -------------------


.PHONY : xpre xfonts xlibs xapps xlibs2 xproto $(XLIBS) $(XLIBS2) $(XPRE) $(PROTO_XLIBS)

fontconfig libpng libjpeg-turbo pixman:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

$(XLIBS) $(XLIBS2) $(PROTO_XLIBS) $(XFONTS) glu freeglut:
	@echo Compile $@-$($@_VERSION)
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $(XORG_CONFIG) $($@_EXTRA_CONFIG)
	cd src/$@; make
	#cd src/$@; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;"
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs
	sed -i~ -e "s; /usr/lib/libxcb.la; $(SYSROOT)/usr/lib/libxcb.la;" $(SYSROOT)/usr/lib/*.la
	sed -i~ -e "s; /usr/lib/libX11.la; $(SYSROOT)/usr/lib/libX11.la;" $(SYSROOT)/usr/lib/*.la

libpciaccess:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; patch -Np1 -i ../../patches/libpciaccess_PATH_MAX.patch
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $(XORG_CONFIG)  $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

$(XAPPS):
	@echo Compile $@-$($@_VERSION)
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $(XORG_CONFIG)  $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la


xterm_VERSION = -269
xterm_EXTRA_CFLAGS=-include termcap.h -g -D__GNU__ -D__GLIBC__=2 -D__GLIBC_MINOR__=10 -D_POSIX_SOURCE -D_GNU_SOURCE
xterm:
	@echo Compile $@-$($@_VERSION)
	$(call extractpatch,$@,$($@_VERSION))
	#cd src/$@; sed -i '/v0/,+1s/new:/new:kb=^?:/' termcap
	#cd src/$@; echo -e '\tkbs=\\177,' >>terminfo
	#cd src/$@; TERMINFO=/usr/share/terminfo CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) --enable-luit --enable-wide-chars --with-app-defaults=/etc/X11/app-defaults
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) --enable-256-color --enable-wide-chars --with-app-defaults=/etc/X11/app-defaults ac_cv_header_lastlog_h=no cf_cv_path_lastlog=no
	#cd src/$@; touch curses.h
	cd src/$@; echo "#ifndef HACKY_HACKY_GETPT" >> ptyx.h
	cd src/$@; echo "#define HACKY_HACKY_GETPT" >> ptyx.h
	cd src/$@; echo 'static inline int getpt() { return open("/dev/ptmx",O_RDWR|O_NOCTTY); }' >> ptyx.h
	cd src/$@; echo "#endif" >> ptyx.h
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

font-bh-75dpi font-bh-ttf font-adobe-75dpi:
	@echo Compile $@-$($@_VERSION)
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $(XORG_CONFIG) $($@_EXTRA_CONFIG)
	cd src/$@; make UTIL_DIR=$(SYSROOT)/usr/share/fonts/X11/util
	cd src/$@; make install DESTDIR=$(SYSROOT)

libxcb:
	@echo Compile $@-$($@_VERSION)
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; sed "s/pthread-stubs//" -i configure
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $(XORG_CONFIG)  $($@_EXTRA_CONFIG)
	cd src/$@; make
	#cd src/$@; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;"
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la
	sed -i~ -e "s; /usr/lib/libxcb.la; $(SYSROOT)/usr/lib/libxcb.la;" $(SYSROOT)/usr/lib/*.la
	sed -i~ -e "s; /usr/lib/libX11.la; $(SYSROOT)/usr/lib/libX11.la;" $(SYSROOT)/usr/lib/*.la

freetype:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" 		\
	LIBPNG_CFLAGS="-I$(SYSROOT)/usr/include/libpng16"	\
	LIBPNG_LDFLAGS="-L$(SYSROOT)/usr/lib -lpng16"		\
	./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

#Applying patch http://lists.freedesktop.org/archives/mesa-users/2013-February/000569.html

Mesa_VERSION = -9.2.0
Mesa_EXTRA_CONFIG= --enable-osmesa --disable-gallium-egl \
--disable-dri --enable-xlib-glx --with-gallium-drivers= --with-dri-drivers=
Mesa_EXTRA_CFLAGS=-D_GNU_SOURCE -mhard-float

#--enable-gles2 	--enable-egl  --with-dri-drivers=swrast \
#--with-egl-platforms=drm,wayland --with-gallium-drivers=swrast --enable-gbm --enable-shared-glapi

Mesa:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; patch -Np1 -i ../../patches/MesaLib-9.2.0-add_xdemos-1.patch
	cd src/$@; patch -Np1 -i ../../patches/mesalib-strtod.patch
	cd src/$@; patch -Np1 -i ../../patches/mesalib-strtof.patch
	cd src/$@; patch -Np1 -i ../../patches/mesalib-fpclassify.patch
	cd src/$@; autoreconf -fi
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make install DESTDIR=$(SYSROOT)
	#cd src/$@; sed -i~ -e "s;ifneq (;ifeq (;" xdemos/Makefile
	#cd src/$@; CC=$(CC) make -C xdemos DEMOS_PREFIX=/usr  
	#cd src/$@; make -C xdemos DEMOS_PREFIX=/usr DESTDIR=$(SYSROOT) install 
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la
	sed -i~ -e "s; /usr/lib; $(SYSROOT)/usr/lib;" $(SYSROOT)/usr/lib/libEGL*.la
	sed -i~ -e "s; /usr/lib; $(SYSROOT)/usr/lib;" $(SYSROOT)/usr/lib/libGL*.la
	#sed -i~ -e "s; /usr/lib; $(SYSROOT)/usr/lib;" $(SYSROOT)/usr/lib/libGLESv2*.la
	#sed -i~ -e "s; /usr/lib; $(SYSROOT)/usr/lib;" $(SYSROOT)/usr/lib/libgbm*.la
	sed -i~ -e "s; /usr/lib; $(SYSROOT)/usr/lib;" $(SYSROOT)/usr/lib/libOSMesa*.la
	echo "#define __NOT_HAVE_DRM_H" > $(SYSROOT)/usr/include/GL/internal/dri_interface.h
	cat src/Mesa/include/GL/internal/dri_interface.h >> $(SYSROOT)/usr/include/GL/internal/dri_interface.h
	

#nano $(SYSROOT)/usr/include/GL/internal/dri_interface.h

xorg-server_VERSION = -1.14.3
xorg-server_EXTRA_CONFIG = 	\
--disable-dri --disable-dri2 \
--disable-xselinux --disable-xdm-auth-1 \
--disable-xorg --disable-xwin 	\
--enable-kdrive --enable-xfbdev --enable-kdrive-evdev		\
--enable-xf86vidmode --enable-kdrive-mouse \
--disable-xfake --disable-config-udev -enable-tslib 		\
--disable-tcp-transport --disable-ipv6	\
--disable-libdrm \
--with-xkb-output=/var/lib/xkb \
--enable-install-setuid
xorg-server_EXTRA_CFLAGS=-D_GNU_SOURCE -D__gid_t=gid_t -D__uid_t=uid_t

xorg-server:
	echo Compile $@-$($@_VERSION)
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; printf "all:\n\ttrue\n\ninstall:\n\ttrue\n\n" > test/Makefile.in
	cd src/$@; sed -i 's/termio.h/termios.h/' hw/xfree86/os-support/xf86_OSlib.h 
	cd src/$@; echo "#define IMAGE_BYTE_ORDER        MSBFirst" >> include/servermd.h
	cd src/$@; echo "#define BITMAP_BIT_ORDER        MSBFirst" >> include/servermd.h
	cd src/$@; echo "#define GLYPHPADBYTES           4" >> include/servermd.h
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $(XORG_CONFIG) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	#sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

glew:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; sed -i~ -e "s;-L/usr/X11R6/lib64;;" config/*
	cd src/$@; sed -i~ -e "s;-L/usr/lib64;;" config/*
	cd src/$@; make CC=$(TOOLCHAIN_TARGET)-gcc  LD=$(TOOLCHAIN_TARGET)-gcc  STRIP=$(TOOLCHAIN_TARGET)-strip
	cd src/$@; make install GLEW_DEST=$(SYSROOT)/usr LIBDIR=$(SYSROOT)/usr/lib

demos-mesa-demos_VERSION=-8.1.0
demos-mesa-demos:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./autogen.sh
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make

fvwm_VERSION=-2.6.5
fvwm_EXTRA_CONFIG=--disable-option-checking	\
--disable-mandoc	\
--disable-sm	\
--disable-shape	\
--disable-xinerama	\
--disable-xrender	\
--disable-xft	\
--disable-freetypetest	\
--disable-fontconfigtes	\
 --disable-xfttest	\
--disable-rsvg	\
--disable-perllib	\
--disable-gtk

fvwm:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ac_cv_func_setpgrp_void=no CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make

icewm_VERSION=-1.3.8
icewm_EXTRA_CONFIG=--disable-i18n
icewm:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make



fluxbox_VERSION = -1.3.5
fluxbox_EXTRA_CONFIG = --enable-nls --disable-xrender --disable-xinerama --disable-shape --disable-randr --disable-fribidi --disable-imlib2
fluxbox: ac_cv_func_malloc_0_nonnull=no
fluxbox: ac_cv_func_realloc_0_nonnull=no
fluxbox:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; sed -i~ -e "s;rpl_malloc;malloc;" config.h
	cd src/$@; sed -i~ -e "s;rpl_realloc;realloc;" config.h
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

xbomb:
	#$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; make CC=$(TOOLCHAIN_TARGET)-gcc


xtic_VERSION=1.12
xtic:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/xtic/src;or1k-linux-gcc *.c -o xtic -lXpm -lXt -lX11 -lXaw


xli_VERSION = -1.16
xli:
	mkdir -p src/xli
	cd src/xli; tar -xvzf ../../downloads/xli-1.16.tar.gz
	cd src/xli; cp Makefile.std Makefile
	cd src/xli; make STD_CC=$(TOOLCHAIN_TARGET)-gcc
	#cd src/xtic/src;or1k-linux-gcc *.c -o xtic -lXpm -lXt -lX11 -lXaw

mesa-demos_VERSION=-8.2.0
mesa-demos:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 -mhard-float" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)	
	cd src/$@; make

MesaGLUT_VERSION=-7.9.2
MesaGLUT:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)	
	cd src/$@; make



#remove "test" form Makefile DIRS variable
fltk_VERSION=-1.3.2
fltk_EXTRA_CONFIG=--enable-shared --enable-threads --with-x --disable-gl --enable-localjpeg --enable-localzlib --enable-localpng
fltk:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)	
	cd src/$@; sed -i 's@fluid test documentation@fluid documentation@' Makefile
	#cd src/$@; CC=or1k-linux-musl-gcc CXX=or1k-linux-musl-g++ CFLAGS="-O2" ./configure $($@_EXTRA_CONFIG)	
	cd src/$@; sed -i 's@.SILENT:@@' makeinclude
	cd src/$@; make

dillo_VERSION=-3.0.4
dillo:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST) $(XORG_CONFIG) $($@_EXTRA_CONFIG) --enable-ssl	
	cd src/$@; make 
