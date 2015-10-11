fire_VERSION = -1.0
musl_VERSION = -4.9.0
openssl_VERSION = -1.0.1h
busybox_VERSION = -1.22.1
#busybox_VERSION = -snapshot
nano_VERSION = -2.2.6
nano_EXTRA_CONFIG= --disable-nanorc --sysconfdir=/etc
joe_VERSION = -3.7
joe_EXTRA_CONFIG = --sysconfdir=/etc
ncurses_VERSION = -5.9
ncurses_EXTRA_CONFIG = --disable-database --with-fallbacks="linux vt100 xterm" --disable-nls --without-dlsym --without-cxx-binding --disable-docs --without-debug --with-shared
#DirectFB_VERSION = -1.6.3
DirectFB_VERSION = -1.7.6
DirectFB-examples_VERSION = -1.6.0
SDL_VERSION = -1.2.15
tslib_VERSION = -1.1
scummvm_VERSION = -1.6.0
frotz_VERSION = -2.43d
physfs_VERSION = -2.0.3

qemu_VERSION = -1.6.0
qemu_EXTRA_CONFIG = --target-list=i386-softmmu,i386-linux-user --enable-tcg-interpreter --disable-gtk

bochs_VERSION = -20131025
bochs_EXTRA_CONFIG = --with-term 
#--with-sdl

zlib_VERSION = -1.2.8

expat_VERSION = -2.1.0
expat_EXTRA_CONFIG = --disable-static

bc_VERSION = -1.06.95


PROGS = busybox nano mcookie bc lua nbench-byte coremark

libs: prelibs $(TOOLCHAIN) zlib ncurses openssl expat tslib alsa-lib libffi #glib
progs: $(PROGS)
graphics: libpng libjpeg-turbo freetype fontconfig pixman SDL SDL_mixer
network: lynx openssh nmap curl

#TODO: what is libtool --finish /usr/lib

prelibs:
	mkdir -p $(SYSROOT)/var
	mkdir -p $(SYSROOT)/etc
	mkdir -p $(SYSROOT)/bin
	mkdir -p $(SYSROOT)/sbin
	mkdir -p $(SYSROOT)/root

postlibs:
	#sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la
	find $(SYSROOT)/usr/lib/ -name "*.la" -exec sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;g" {} \;
	find $(SYSROOT)/usr/lib/ -name "*.la" -exec sed -i~ -e "s;dependency_libs=' /usr;dependency_libs=' $(SYSROOT)/usr;g" {} \;
	find $(SYSROOT)/usr/lib/ -name "*.la" -exec sed -i~ -e "s; /usr; $(SYSROOT)/usr;g" {} \;



mcookie:
	cp patches/mcookie $(SYSROOT)/sbin
	chmod u+x $(SYSROOT)/sbin/mcookie


linux_headers:
	cd src/linux/; make ARCH=openrisc INSTALL_HDR_PATH=${SYSROOT}/usr headers_install

busybox: 
	$(call extractpatch,$@,$($@_VERSION))
	cp patches/CONFIG_BUSYBOX src/busybox/.config
	#sed -i~ -e "s;.*CONFIG_SYSROOT.*;CONFIG_SYSROOT=\"$(SYSROOT)\";" src/busybox/.config
	sed -i~ 's/.*CONFIG_CROSS_COMPILER_PREFIX.*/CONFIG_CROSS_COMPILER_PREFIX="$(TOOLCHAIN_TARGET)-"/g' src/busybox/.config
	cd src/busybox; make 
	cd src/busybox; make CONFIG_PREFIX=$(SYSROOT) install

zlib:
	@echo Compile $@-$($@_VERSION)
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CC=$(TOOLCHAIN_TARGET)-gcc CFLAGS="$($@_EXTRA_CFLAGS)" ./configure --prefix=/usr $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	cp patches/libz.la $(SYSROOT)/usr/lib/
	#cp patches/libgcc_s.la $(SYSROOT)/usr/lib/
	make postlibs

gnu:
	@echo "This seems to be in place"

alsa-utils_VERSION = -1.0.28
alsa-utils_EXTRA_CONFIG = --disable-xmlto
alsa-lib_VERSION = -1.0.28
alsa-lib_EXTRA_CONFIG = --disable-python
alsa-utils alsa-lib expat ncurses:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-mhard-float -O2" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la


libdrm_VERSION = -2.4.46
libdrm_EXTRA_CONFIG = --disable-libkms
mtdev_VERSION = -1.1.4
mtdev_EXTRA_CONFIG = --disable-static


links_VERSION = -2.8
links_EXTRA_CONFIG = --enable-graphics --without-x --with-ssl  --with-fb

lynx_VERSION = 2-8-8
lynx_EXTRA_CONFIG = --with-zlib --with-screen=ncurses --sysconfdir=/etc/lynx --with-ssl

nmap_VERSION = -6.46
nmap_EXTRA_CONFIG = --with-libpcap=included --without-liblua --with-pcap=linux --without-zenmap --without-ndiff --without-subversion --without-nmap-update

#nmap_EXTRA_CONFIG = --disable-nls --with-pcap=included --without-liblua --without-zenmap
#nmap_EXTRA_CONFIG = --disable-nls --with-pcap=linux --without-liblua --without-zenmap

libpcap_VERSION = -1.5.3
libpcap_EXTRA_CONFIG = --with-pcap=included

lua_VERSION = -5.2.2

w3m_VERSION = -0.5.3
w3m_EXTRA_CONFIG = 

openssh_VERSION = -6.6p1
openssh_EXTRA_CONFIG = -sysconfdir=/etc/ssh --datadir=/usr/share/sshd --with-md5-passwords --disable-strip --disable-lastlog --disable-wtmp

traceroute_VERSION = -2.0.19

curl_EXTRA_CONFIG = --with-ssl --with-ca-path=/etc/ssl/certs
curl_VERSION = -7.37.1
#curl_CONF_ENV = CFLAGS="-fpic"

webkitgtk_VERSION = -2.2.1
webkitgtk_EXTRA_CONFIG = --disable-video --disable-webgl  --with-target=directfb 

libwebp_VERSION = -0.3.1
libexif_VERSION = -0.6.21

iperf_VERSION = -2.0.5
iperf_CONF_ENV = ac_cv_func_malloc_0_nonnull=yes 

irssi_VERSION = -0.8.16-rc1


weechat_VERSION = -0.4.2
ScrollZ_VERSION = -2.2.2

libiconv_VERSION = -1.14
libiconf_EXTRA_CONFIG = --disable-nls

gettext_VERSION = -0.18.3.1
gettext_EXTRA_CONFIG = --disable-nls --disable-threads

libgcrypt_VERSION = -1.5.3
libgpg-error_VERSION = -1.12

#both don't work
netkit-ntalk_VERSION = -0.17
util-linux_VERSION = -2.24

ytalk_VERSION = -3.3.0
ytalk_EXTRA_CONFIG = --sysconfdir=/etc

netsurf_VERSION = -all-3.2



physfs: 
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; mkdir -p build;
	cd src/$@/build; cmake .. \
		-DCMAKE_TOOLCHAIN_FILE=../../../patches/CMake_Cross_Compiling	\
		-DCMAKE_INSTALL_PREFIX=$(SYSROOT)/usr
	cd src/$@/build; make
	cd src/$@/build; make install

netsurf ytalk libgpg-error libgcrypt libiconv irssi libexif libwebp nano joe libdrm mtdev w3m libpcap curl qemu bochs webkitgtk:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; $($@_CONF_ENV) ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	#sed -i~ -e "s;lt_sysroot=;lt_sysroot=$(SYSROOT);" src/$@/libtool
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

#see http://sourceforge.net/p/mingw-w64/bugs/396/
cairo_CONF_ENV = LDFLAGS="-fno-lto -fuse-linker-plugin" CFLAGS="-fno-lto"
#cairo_VERSION = -1.12.16
cairo_VERSION = -1.14.0
cairo_EXTRA_CONFIG = --enable-ps=yes --enable-pdf=yes --enable-svg=yes --enable-xml=yes --enable-win32-font=no --enable-win32=no 	\
--enable-quartz-font=no --enable-quartz=no --enable-xlib-xrender=no --enable-xlib=yes --enable-win32-font=no	\
--enable-gtk-doc-html=no --enable-script=no --enable-trace=no
#--enable-gobject=no
#--enable-gl=yes 
#cairo_CONF_ENV = CFLAGS="-O2 -mhard-float -fno-lto"
cairo_CONF_ENV = CFLAGS="-O2 -mhard-float"


cairo:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; $($@_CONF_ENV) ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make V=1
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/cairo/*.la


toppler_VERSION = -1.1.6
toppler_EXTRA_CONFIG = --with-sdl-prefix=$(SYSROOT)/usr --datarootdir=/usr/share/games/toppler --localstatedir=/var
toppler:
	$(call extractpatch,$@,$($@_VERSION))
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la
	cd src/$@; $($@_CONF_ENV) ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	sed -i~ -e "s;SCREENHEI 480;SCREENHEI 400;" src/$@/decl.h
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)


d1x-rebirth_VERSION=_v0.58.1-src
d1x-rebirth:
	$(call extractpatch,$@,$($@_VERSION))
	sed -i~ -e "s;return \"little\";return \"big\";" src/$@/SConstruct
	cd src/$@; CFLAGS="-mhard-float -O2" CC=or1k-linux-musl-gcc scons opengl=0 asm=0 sdlmixer=0 verbosebuild=1 sharepath=/usr/share/d1x-rebirth

dxx-rebirth:
	#cd src/$@; git reset --hard
	#cd src/$@; git clean -f -d
	#cd src/$@; git clean -f -X
	cd src/$@; scons -c
	#cd src/$@; sed -i~ -e "s;return \"little\";return \"big\";" SConstruct
	#cd src/$@; CFLAGS="-mhard-float -DWORDS_NEED_ALIGNMENT" CXX=or1k-linux-musl-g++  CC=or1k-linux-musl-gcc scons opengl=0 asm=0 sdlmixer=0 verbosebuild=1 sharepath=/usr/share/d1x-rebirth d1x=1 d2x=0
	#cd src/$@; CXX=or1k-linux-musl-g++  CC=or1k-linux-musl-gcc scons endian=big opengl=0 asm=0 sdlmixer=0 verbosebuild=1 sharepath=/usr/share/d1x-rebirth d1x=1 d2x=0
	cd src/$@; scons opengl=0 asm=0 verbosebuild=1 sharepath=/usr/share/d1x-rebirth d1x=1 d2x=0 endian=big

freera++:
	#cd src/freera++; rm -rf *
	#cd src; svn co https://freera.svn.sourceforge.net/svnroot/freera/freera++/trunk freera++
	cd src/$@; scons -c
	#cd $(TOOLCHAIN_DIR)/bin; ln -s or1k-linux-musl-g++ g++
	cd src/$@; PATH=$(TOOLCHAIN_DIR)/bin:$(PATH) scons
	#cd src/$@; make clean
	#cd src/$@; make CXX=or1k-linux-musl-g++ CXXFLAGS="-mhard-float -O2"

prboom_VERSION = -2.5.0
prboom_EXTRA_CONFIG=--disable-gl --disable-sdltest --disable-cpu-opt --with-sdl-prefix=$(SYSROOT)/usr
prboom:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; $($@_CONF_ENV) ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	sed -i~ -e "s;png_error_ptr_NULL;NULL;" src/prboom/src/SDL/i_sshot.c
	sed -i~ -e "s;png_infopp_NULL;NULL;" src/prboom/src/SDL/i_sshot.c
	#sed 's,.*#undef WORDS_BIGENDIAN.*,#define WORDS_BIGENDIAN 1,g' src/prboom/config.h
	echo "#define WORDS_BIGENDIAN 1" >> src/prboom/config.h
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la


MPlayer_VERSION = -1.1.1

MPlayer_EXTRA_CONFIG = 	\
--confdir=/etc/mplayer		\
--prefix=/usr		\
--target=or1k-linux-musl \
--disable-ssse3		\
--disable-mencoder	\
--disable-iconv		\
--disable-networking	\
--enable-big-endian	\
--disable-vm		\
--disable-gl		\
--disable-vidix		\
--disable-ivtv		\
--disable-xv		\
--disable-x11		\
--disable-xss		\
--enable-fbdev		\
--enable-sdl		\
--disable-directfb	\
--enable-alsa		\
--disable-ossaudio	\
--enable-cross-compile	\
--cc=or1k-linux-musl-gcc	\
--as=or1k-linux-musl-as	\
--disable-runtime-cpudetection \
--yasm=''			\


#--extra-cflags=-mhard-float


MPlayer:
	#$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; sed -i 's:as_verc_fail" != yes:as_verc_fail" != no:' configure  
	cd src/$@; sed -i 's:vax):or1k):' configure  
	cd src/$@; sed -i "s:arch='vax':arch='generic':" configure  
	cd src/$@; sed -i "s:iproc='vax'::" configure  
	cd src/$@; $($@_CONF_ENV) ./configure  $($@_EXTRA_CONFIG)
	cd src/$@; sed -i 's:= -s:=:' config.mak  
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)



ircii:
	$(call extractpatch,$@,$($@_VERSION))
	-cd src/$@; autoconf
	cd src/$@; $($@_CONF_ENV) ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)



#remove -rdynamic option  in /usr/share/cmake/
weechat:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; mkdir -p build
	cd src/$@/build; cmake .. -DPREFIX=/usr \
		-DCMAKE_TOOLCHAIN_FILE=../../../patches/CMake_Cross_Compiling	\
		-DENABLE_RUBY=OFF	\
		-DENABLE_NCURSES=ON	\
		-DENABLE_GTK=OFF	\
		-DENABLE_NLS=OFF	\
		-DENABLE_LUA=OFF
	cd src/$@/build; make
	cd src/$@/build; make install DESTDIR=$(SYSROOT)



iperf: ac_cv_func_malloc_0_nonnull = yes
iperf: ac_cv_func_realloc_0_nonnull = yes
iperf:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; $($@_CONF_ENV) ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)


fbida_VERSION = -2.09

fbida:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; make CC=$(TOOLCHAIN_TARGET)-gcc CFLAGS="-O2"
	make prefix=/usr DESTDIR=$(SYSROOT) install

frotz:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; make CC=$(TOOLCHAIN_TARGET)-gcc CONFIG_DIR=/etc
	cp src/$@/frotz $(SYSROOT)/usr/bin/


traceroute:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; make CC=$(TOOLCHAIN_TARGET)-gcc
	cd src/$@; make prefix=$(SYSROOT)/usr install

lynx:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; sed -i 's/define ACCEPT_ALL_COOKIES FALSE/define ACCEPT_ALL_COOKIES TRUE/' userdefs.h
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; echo "#define USE_OPENSSL_INCL 1" >> lynx_cfg.h
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	#sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

links:
	$(call extractpatch,$@,$($@_VERSION))
	sed -i~ -e "s;*last_val;last_val;" src/links/dip.c
	cd src/$@; CC=$(TOOLCHAIN_TARGET)-gcc ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la



openssh:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; patch -Np1 -i ../../patches/openssh-fix-includes.diff
	cd src/$@; patch -Np1 -i ../../patches/openssh-fix-utmp.diff
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	#sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la



dosbox_VERSION = -0.74
dosbox_EXTRA_CONFIG = --disable-opengl --disable-dynamic-core --with-sdl-prefix=$(SYSROOT)/usr --disable-sdltest --enable-core-inline
dosbox:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; sed -i~ -e "s;#define USE_FULL_TLB;#undef USE_FULL_TLB;" include/paging.h
	cd src/$@; sed -i~ '/#define DOSBOX_DOS_INC_H/a#include<stddef.h>' include/dos_inc.h
	cd src/$@; sed -i~ -e "s;-lX11;;" configure
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; sed -i~ -e "s;#define C_X11_XKB;//#define C_X11_XKB;" config.h
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

openssl:
	$(call extractpatch,$@,$($@_VERSION))
	#cd src/$@; sed -i 's/defined(linux)/!defined(linux)/g' crypto/ui/ui_openssl.c
	cd src/$@; patch -Np1 -i ../../patches/linux/linux-musl-libc-termios.patch
	cd src/$@; patch -Np1 -i ../../patches/openssl-1.0.1h-fix_parallel_build-1.patch
	#cd src/$@; patch -Np1 -i ../../patches/openssl-1.0.1e-fix_pod_syntax-1.patch
	#cd src/$@; find . -type f -name "*.c" -print0 | xargs -r -0 sed -i -e "s;<termio.h>;<termios.h>;"
	cd src/$@; ./Configure linux-generic32 shared --prefix=/usr --libdir=lib --openssldir=/etc/ssl zlib-dynamic -DB_ENDIAN
	cd src/$@; make CC="$(TOOLCHAIN_TARGET)-gcc" AR="$(TOOLCHAIN_TARGET)-ar r" RANLIB="$(TOOLCHAIN_TARGET)-ranlib" LD="$(TOOLCHAIN_TARGET)-ld"
	#CFLAGS="-D_GNU_SOURCE -D_BSD_SOURCE" 
	cd src/$@; make INSTALL_PREFIX=$(SYSROOT) install
	#$(TOOLCHAIN_TARGET)-ranlib $(SYSROOT)/usr/lib/libssl.a
	#$(TOOLCHAIN_TARGET)-ranlib $(SYSROOT)/usr/lib/libcrypt.a

fire:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 -lgcc_s" CC="or1k-linux-musl-gcc" ./configure $(CONFIG_HOST)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)


bc:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

DirectFB:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; patch -Np1 -i ../../patches/directfb-sigval.patch
	#cd src/$@; sed -i~ -e "s;PTHREAD_MUTEX_INITIALIZER;0;" lib/direct/os/linux/glibc/mutex.h
	cd src/$@; sed -i~ -e "s;PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;0;" lib/direct/os/linux/glibc/mutex.h
	#sed -i~ -e "s;#ifdef DIRECT_BUILD_NO_SA_SIGINFO;#if 1;" src/DirectFB/lib/direct/signals.c
	#sed -i~ -e "s;#ifdef WIN32;#ifndef WIN32;" src/DirectFB/lib/direct/atomic.h
	#sed -i~ -e "s;lt_sysroot=;lt_sysroot=$(SYSROOT);" src/$@/libtool
	cd src/$@; CFLAGS="-O2 -fpic -DDIRECT_BUILD_NO_SA_SIGINFO=1" ./configure $(CONFIG_HOST)	\
		--program-prefix= 	\
		--disable-network	\
		--disable-multicore	\
		--disable-x11			\
		--with-gfxdrivers=none		\
		--with-inputdrivers=tslib,keyboard,linuxinput	\
		--sysconfdir=/etc
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la
	sed -i~ -e "s; /usr/lib/libdirect.la; $(SYSROOT)/usr/lib/libdirect.la;" $(SYSROOT)/usr/lib/*.la
	sed -i~ -e "s; /usr/lib/libfusion.la; $(SYSROOT)/usr/lib/libfusion.la;" $(SYSROOT)/usr/lib/*.la
	cp patches/init/etc/directfbrc $(SYSROOT)/etc/


#for the pkg-config script look at autotools-mythbuster/pkgconfig/cross-compiling.html
DirectFB-examples:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 -mhard-float -I$(SYSROOT)/usr/include/directfb" ./configure $(CONFIG_HOST)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

SDL2_VERSION = -2.0.3
SDL2_EXTRA_CONFIG = --enable-video-directfb --disable-video-x11 --disable-dbus --disable-libudev --without-x
SDL2:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs


SDL:
	$(call extractpatch,$@,$($@_VERSION))
	#cd src/$@; sed -i~ -e "s;4321;1234;" configure
	cd src/$@; CFLAGS="-O2 -mhard-float" ./configure $(CONFIG_HOST) --disable-alsatest --disable-pulseaudio --enable-arts --enable-video-fbcon --disable-video-directfb --disable-x11-shared --disable-osmesa-shared --disable-video-x11 --disable-video-opengl --enable-input-events
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;prefix=/usr;prefix=$(SYSROOT)/usr;" $(SYSROOT)/usr/bin/sdl-config
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la


SDL_mixer_VERSION=-1.2.12
SDL_mixer:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST) --disable-sdltest --disable-music-mod --disable-smpegtest
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

SDL_image_VERSION=-1.2.12
SDL_image:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST) --disable-sdltest --disable-music-mod
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)


SDL-examples:
	cd src/SDL/test; CFLAGS="-O2" ./configure $(CONFIG_HOST)
	sed -i~ -e "s;480;400;" src/SDL/test/*
	sed -i~ -e "s;-L/usr/lib; ;" src/SDL/test/Makefile
	cd src/SDL/test; make clean
	cd src/SDL/test; make
	mkdir -p $(SYSROOT)/test2
	cp src/SDL/test/* $(SYSROOT)/test2/


#		--enable-sdl2

scummvm: 
	#$(call extractpatch,$@,$($@_VERSION))
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la
	cd src/$@; CFLAGS="-O2" CXXFLAGS="-O2" ./configure $(CONFIG_HOST) \
		--disable-all-engines 		\
		--enable-engine-static=scumm 	\
		--with-sdl-prefix=$(SYSROOT)/usr \
                --enable-verbose-build		\
		--disable-hq-scalers 		\
		--disable-translation 		\
		--disable-bink 			\
		--disable-debug 		\
		--enable-release		\
		--disable-vorbis		\
		--disable-opengl		\
		--disable-flac			\
		--disable-theoradec
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

tslib: ac_cv_func_malloc_0_nonnull = yes
tslib:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./autogen.sh
	cd src/$@; ../../scripts/fixoldacconfig
	cd src/$@; CFLAGS="-O2 -fpic" ./configure $(CONFIG_HOST) --sysconfdir=/etc
	cd src/$@; sed -i~ -e "s;rpl_malloc;malloc;" tests/fbutils.c
	cd src/$@; sed -i~ -e "s;rpl_malloc;malloc;" config.h
	cd src/$@; make
	#cd src/$@; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;"
	#cd src/$@; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "s; /usr; $(SYSROOT)/usr;"
	cd src/$@; make install DESTDIR=$(SYSROOT)
	echo "module_raw input" > $(SYSROOT)/etc/ts.conf
	echo "65596 109 -80720 60 65424 -52568 65536 640 400" > $(SYSROOT)/etc/pointercal

sdlquake_VERSION = -1.0.9
sdlquake:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; patch -Np1 -i ../../patches/sdlquake-no-x86-asm.diff
	cd src/$@; cp ../libX11/config.sub .
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST) --disable-asm --disable-sdltest
	cd src/$@; make

quakespasm_VERSION = -0.85.9
quakespasm:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@/Quake; make CC=or1k-linux-musl-gcc CFLAGS="-O2 -mhard-float" STRIP=or1k-linux-musl-strip

quakeforge_VERSION = -0.7.2
quakeforge:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 -mhard-float" ./configure $(CONFIG_HOST) --with-endian=big --with-fbdev --with-servers=  --with-tools=  
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

tyrquake_VERSION = -0.61
tyrquake:
	$(call extractpatch,$@,$($@_VERSION))
	#cd src/$@; make CFLAGS="-O2 -mhard-float" STRIP=or1k-linux-musl-strip CC=or1k-linux-musl-gcc USE_X86_ASM=N prepare V=1 tyr-qwcl
	#cd src/$@; make CFLAGS="-O2 -mhard-float" STRIP=or1k-linux-musl-strip CC=or1k-linux-musl-gcc USE_X86_ASM=N prepare V=1 tyr-glquake
	cd src/$@; make CFLAGS="-O2 -mhard-float" STRIP=or1k-linux-musl-strip CC=or1k-linux-musl-gcc USE_X86_ASM=N prepare V=1 tyr-quake
	#cd src/$@; make CFLAGS="-O2 -mhard-float" STRIP=or1k-linux-musl-strip CC=or1k-linux-musl-gcc USE_X86_ASM=N prepare V=1 tyr-quake
	#cd src/$@; make CFLAGS="-O2 -mhard-float" STRIP=or1k-linux-musl-strip CC=or1k-linux-musl-gcc USE_X86_ASM=N prepare V=1 tyr-glqwcl
	#cd src/$@; make CFLAGS="-O2 -mhard-float" STRIP=or1k-linux-musl-strip CC=or1k-linux-musl-gcc USE_X86_ASM=N prepare V=1 tyr-qwsv
	#cd src/$@; make CFLAGS="-O2 -mhard-float" STRIP=or1k-linux-musl-strip CC=or1k-linux-musl-gcc USE_X86_ASM=N prepare V=1

strace_VERSION = -4.8
strace:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; patch -Np1 -i ../../patches/strace-musl.patch
	cd src/$@; patch -Np1 -i ../../patches/strace-kernelhdr_3.12.6.patch
	cd src/$@; sed -i -e 's/include <linux\/kernel.h>//g' resource.c
	cd src/$@; sed -i -e 's/include <linux\/socket.h>/include <sys\/socket.h>/g' configure
	cd src/$@; LDFLAGS="-static" CFLAGS="-O2 -Dsigcontext_struct=sigcontext" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

systemd_VERSION = -207
systemd:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST)

gettext_VERSION = -0.18.3.1


#glib_VERSION = -2.36.4
glib_VERSION = -2.40.0
glib_EXTRA_CONFIG = 			\
	--disable-iconv-cache 		\
	--disable-static 		\
	--disable-modular-tests 	\
	--disable-selinux 		\
	--disable-fam 			\
	--disable-silent-rules glib_cv_stack_grows=no glib_cv_uscore=no \
	ac_cv_func_posix_getpwuid_r=yes ac_cv_func_posix_getgrgid_r=yes

#--with-libiconf=no

glib:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 -D_GNU_SOURCE -D_BSD_SOURCE -Dloff_t=off_t" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; echo '#include <string.h>' >> config.h
	cd src/$@; echo true > missing
	cd src/$@; make V=1
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs


libxkbcommon_VERSION = -0.3.1
libxkbcommon_EXTRA_CONFIG = --disable-static
libxkbcommon gettext:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la


eudev_VERSION = -1.3
eudev_EXTRA_CONFIG = --disable-introspection --disable-selinux  \
--disable-libkmod --disable-keymap --disable-gtk-doc --disable-gudev --disable-static \
--disable-manpages 	\
--bindir=/sbin		\
--sbindir=/sbin		\
--libdir=/usr/lib 	\
--sysconfdir=/etc 	\
--libexecdir=/lib	\
--with-rootprefix=	\
--with-rootlibdir=/lib	\
--enable-split-usr	\
--disable-gudev

eudev:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; sed -i~ -e "s;__thread ;;" src/libudev/*
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

libffi_EXTRA_CONFIG = --disable-static
libffi_VERSION = -3.2.1
libffi:
	#dont overwrite this
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; touch ./autogen.sh; chmod +x ./autogen.sh
	cd src/$@; ./autogen.sh
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make clean
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

libpthread-stubs_VERSION=-0.1
libpthread-stubs:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la



#wayland_VERSION = -1.2.1
wayland_VERSION = -1.6.0
wayland_EXTRA_CONFIG = --disable-documentation --disable-static
wayland:
	find $(SYSROOT)/usr/lib/ -name "*.la" -exec sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;g" {} \;
	find $(SYSROOT)/usr/lib/ -name "*.la" -exec sed -i~ -e "s;dependency_libs=' /usr;dependency_libs=' $(SYSROOT)/usr;g" {} \;
	find $(SYSROOT)/usr/lib/ -name "*.la" -exec sed -i~ -e "s; /usr; $(SYSROOT)/usr;g" {} \;
	$(call extractpatch,$@,$($@_VERSION))
	#./autogen.sh
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	sed -i~ -e "s;wayland_scanner = \$$(top_builddir)/wayland-scanner;wayland_scanner = wayland-scanner;" src/$@/Makefile 
	cd src/$@; make V=1
	cd src/$@; make install DESTDIR=$(SYSROOT)
	find $(SYSROOT)/usr/lib/ -name "*.la" -exec sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;g" {} \;
	find $(SYSROOT)/usr/lib/ -name "*.la" -exec sed -i~ -e "s;dependency_libs=' /usr;dependency_libs=' $(SYSROOT)/usr;g" {} \;
	find $(SYSROOT)/usr/lib/ -name "*.la" -exec sed -i~ -e "s; /usr; $(SYSROOT)/usr;g" {} \;
	#sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la
	#sed -i~ -e "s; /usr; $(SYSROOT)/usr;" $(SYSROOT)/usr/lib/libwayland-cursor*.la


libinput:
	#cd src/$@; git clone tp://cgit.freedesktop.org/wayland/libinput
	cd src/$@; ./autogen.sh $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

libevdev_VERSION=-1.2
libevdev:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

#weston_VERSION = -1.2.2
weston_VERSION = -1.6.0
weston_EXTRA_CONFIG = 						\
--enable-fbdev-compositor --disable-libunwind 			\
--disable-x11-compositor  --disable-rpi-compositor 		\
--disable-xwayland --disable-drm-compositor 	\
--disable-rdp-compositor 		\
--disable-rpi-compositor					\
--disable-wcap-tools		\
--disable-weston-launch \
--enable-demo-clients	\
--disable-egl --disable-simple-egl-clients	\
--enable-libinput-backend

#--enable-egl --enable-simple-egl-clients
#--disable-xkbcommon
#--with-cairo=gl						
# src/compositor in function weston_output_transform_coordinate
#*x = wl_fixed_from_int(device_x*8/5);
#*y = wl_fixed_from_int(device_y*5/2);


weston:
	$(call extractpatch,$@,$($@_VERSION))
	find $(SYSROOT)/usr/lib/ -name "*.la" -exec sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;g" {} \;
	find $(SYSROOT)/usr/lib/ -name "*.la" -exec sed -i~ -e "s;dependency_libs=' /usr;dependency_libs=' $(SYSROOT)/usr;g" {} \;
	find $(SYSROOT)/usr/lib/ -name "*.la" -exec sed -i~ -e "s; /usr; $(SYSROOT)/usr;g" {} \;
	#cd src/$@; sed -i~ -e "s;F_DUPFD_CLOEXEC;F_DUPFD;" src/tty.c
	#cd src/$@; sed -i~ -e "s;MSG_CMSG_CLOEXEC;0;" src/launcher-util.c
	#cd src/$@; sed -i~ -e "s;| O_CLOEXEC;;" tests/setbacklight.c
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	echo "#undef HAVE_POSIX_FALLOCATE" >> src/$@/config.h
	cd src/$@; make V=1
	cd src/$@; make install DESTDIR=$(SYSROOT)
	#cd src/$@/clients; or1k-linux-musl-gcc -O2 gears.c .libs/window.o .libs/libtoytoolkit.a ../shared/.libs/libshared-cairo.a -o weston-gears -I$(SYSROOT)/usr/include/cairo -I../ -lGL -lm -lcairo -lEGL -lxkbcommon -lwayland-client -lpixman-1 -lpng -ljpeg -lwayland-client -lwayland-cursor
	#cd src/$@/clients; cp weston-gears $(SYSROOT)/usr/bin/


eglibc:
	mkdir -p src/build-eglibc
	rm -rf src/build-eglibc/*
	cd src/build-eglibc; CFLAGS="-O2" ../../src/or1k-eglibc/configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/build-eglibc; make
	cd src/build-eglibc; make install DESTDIR=$(SYSROOT)

nbench-byte_VERSION = -2.2.3
nbench-byte:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; touch pointer
	cd src/$@; touch pointer.h
	cd src/$@; sed -i~ -e "s;NNET.DAT;/usr/share/nbench/NNET.DAT;" nbench1.h
	#cd src/$@; make CC=$(TOOLCHAIN_TARGET)-gcc CFLAGS="-mhard-float -Ofast"
	cd src/$@; make CC=$(TOOLCHAIN_TARGET)-gcc CFLAGS="-msoft-float -Ofast"


libelf_VERSION=-compat-0.152c001
libelf:
	$(call extractpatch,$@,$($@_VERSION))
	#cd src/$@; CC=or1k-linux-musl-gcc ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	#cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; sed -i 's@HEADERS = src/libelf.h@HEADERS = src/libelf.h src/gelf.h@' Makefile
	cd src/$@; CROSS_COMPILE=or1k-linux-musl- make
	cd src/$@; make prefix=/usr DESTDIR=$(SYSROOT) install

elfutils_VERSION = -0.152
elfutils:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; patch -Np1 -i ../../patches/elfutils-portability.patch
	cd src/$@; patch -Np1 -i ../../patches/elfutils-musl-compat.patch
	cd src/$@; sed -i 's@loff_t@off_t@g' libelf/libelf.h
	cd src/$@; sed -i "/stdint/s@.*@&\n#define TEMP_FAILURE_RETRY(x) x\n#define rawmemchr(s,c) memchr((s),(size_t)-1,(c))@" lib/system.h
	cd src/$@; sed -i '/cdefs/d' lib/fixedsizehash.h
	cd src/$@; sed -i -e \
		"s@__BEGIN_DECLS@#ifdef __cplusplus\nextern \"C\" {\n#endif@" \
		-e "s@__END_DECLS@#ifdef __cplusplus\n}\n#endif@" libelf/elf.h
	cd src/$@; sed -i 's@__mempcpy@mempcpy@g' libelf/elf_begin.c 
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG) --program-prefix="eu-" --disable-nls ac_cv_tls=no
	cd src/$@; find . -name Makefile -exec sed -i 's/-Werror//g' '{}' \;
	cd src/$@; find . -name Makefile -exec sed -i 's/if readelf -d $@ | fgrep -q TEXTREL; then exit 1; fi$//' "{}" \;
	cd src/$@; sed -i 's,am__EXEEXT_1 = libelf.so$(EXEEXT),,' libelf/Makefile
	cd src/$@; sed -i 's,install: install-am libelf.so,install: install-am\n\nfoobar:\n,' libelf/Makefile
	cd src/$@; make
	cd src/$@; make prefix=$(SYSROOT)/usr install

ltrace:
	cd src/$@; ./autogen.sh
	cd src/$@; find . -name "config.sub" -exec sed -i 's/or32/or1k/g' {} \;;
	cd src/$@; find . -name "config.sub" -exec sed -i 's/dietlibc/musl/g' {} \;;
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make

sdldoom_VERSION = -1.10
sdldoom_CONF_ENV = CC=$(TOOLCHAIN_TARGET)-gcc
sdldoom:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; $($@_CONF_ENV) ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	#sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

musl:
	#$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; make distclean
	cd src/$@; git clean -d -f
	cd src/$@; git reset --hard
	cd src/$@; ./configure --enable-debug --enable-optimize $(CONFIG_HOST) CC=$(TOOLCHAIN_TARGET)-gcc --prefix=/usr
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	#cp patches/stddef.h $(SYSROOT)/usr/include/



lua_VERSION=-5.2.3
lua:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; patch -Np1 -i ../../patches/lua-5.2.3-shared_library-1.patch
	cd src/$@; sed -i '/#define LUA_ROOT/s:/usr/local/:/usr/:' src/luaconf.h
	export CC=$(TOOLCHAIN_TARGET)-gcc
	export AR=$(TOOLCHAIN_TARGET)-ar
	export RANLIB=$(TOOLCHAIN_TARGET)-ranlib
	cd src/$@; make ansi CC=$(TOOLCHAIN_TARGET)-gcc
	cd src/$@; make INSTALL_TOP=$(SYSROOT)/usr TO_LIB="liblua.so liblua.so.5.2 liblua.so.5.2.3" INSTALL_DATA="cp -d" install


dunelegacy_VERSION = -0.96.3
dunelegacy:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG) --with-sdl-prefix=$(SYSROOT)/usr
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

allegro_VERSION = -5.0.10
allegro:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; mkdir -p build;
	cd src/$@/build; cmake ..


blobby_VERSION = -1.0
blobby:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; cmake .

Frodo_VERSION = -4.1b
Frodo_EXTRA_CONFIG = --with-sdl-prefix=$(SYSROOT)/usr
Frodo:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@/Src; CC=or1k-linux-gcc CXX=or1k-linux-g++ ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@/Src; CC=or1k-linux-gcc make
	#cd src/$@/Src; make install DESTDIR=$(SYSROOT)


#Frodo_VERSION = -4.1b
#Frodo:
#	$(call extractpatch,$@,$($@_VERSION))
#	cd src/$@/Src; ./configure $(CONFIG_HOST) --disable-sdltest --prefix=$(SYSROOT)/usr
#	cd src/$@/Src; make CC=$(TOOLCHAIN_TARGET)-gcc 
#	cd src/$@/Src; make install

coremark_VERSION = _v1.0
coremark:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; make CC=$(TOOLCHAIN_TARGET)-gcc PORT_DIR=linux compile

nmap:
	$(call extractpatch,$@,$($@_VERSION))
	sed -i~ -e "s;#include \"lua.h\";;" src/nmap/ncat/ncat_lua.h
	sed -i~ -e "s;#include \"lualib.h\";;" src/nmap/ncat/ncat_lua.h
	sed -i~ -e "s;#include \"lauxlib.h\";;" src/nmap/ncat/ncat_lua.h
	cd src/$@; $($@_CONF_ENV) ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

pingus_VERSION = -0.7.6
pingus:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

gtk+_VERSION = -2.24.24
gtk+:
	$(call extractpatch,$@,$($@_VERSION))
	sed -i~ -e "s; /usr/lib/libpangoft; $(SYSROOT)/usr/lib/libpangoft;" $(SYSROOT)/usr/lib/libpangocairo-1.0.la
	sed -i~ -e "s; /usr/lib/libpango-1.0; $(SYSROOT)/usr/lib/libpango-1.0;" $(SYSROOT)/usr/lib/libpangocairo-1.0.la
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG) --disable-rebuilds --disable-glibtest --disable-cups --disable-introspection
	cd src/$@; echo '#include <string.h>' >> config.h
	cd src/$@; printf 'all:\n\ttrue\n\ninstall:\n\ttrue\n\nclean:\n\ttrue\n\ndistclean:\n\ttrue' > demos/Makefile
	cd src/$@; printf 'all:\n\ttrue\n\ninstall:\n\ttrue\n\nclean:\n\ttrue\n\ndistclean:\n\ttrue' > tests/Makefile
	cd src/$@; printf 'all:\n\ttrue\n\ninstall:\n\ttrue\n\nclean:\n\ttrue\n\ndistclean:\n\ttrue' > po/Makefile
	cd src/$@; printf 'all:\n\ttrue\n\ninstall:\n\ttrue\n\nclean:\n\ttrue\n\ndistclean:\n\ttrue' > po-properties/Makefile
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	cd src/$@/demos/gtk-demo; make

pango_VERSION = -1.30.0
pango:
	$(call extractpatch,$@,$($@_VERSION))
	#cd src/$@; printf "all:\n\ttrue\n\ninstall:\n\ttrue\n\n" > tests/Makefile.in
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG) --sysconfdir=/etc
	cd src/$@; make V=1
	cd src/$@; make install DESTDIR=$(SYSROOT)

atk_VERSION = -2.12.0
atk:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make V=1
	cd src/$@; make install DESTDIR=$(SYSROOT)


icu_EXTRA_CONFIG = --enable-extras=no --enable-strict=no -disable-static --enable-shared=yes --enable-tests=no --enable-samples=no --enable-dyload=no
icu_CONF_ENV = CPPFLAGS="-O2 -DU_TIMEZONE=0"
icu:
	rm -rf src/icu
	rm -rf src/icubuildA
	rm -rf src/icubuildB
	mkdir -p  src/icubuildA
	mkdir -p  src/icubuildB
	cd src; tar -xvzf ../downloads/icu4c-53_1-src.tgz
	cd src/icubuildA; sh $(PWD)/src/icu/source/runConfigureICU Linux
	cd src/icubuildA; make
	cd src/icubuildB; $($@_CONF_ENV) $(PWD)/src/icu/source/configure $(CONFIG_HOST) --with-cross-build=$(PWD)/src/icubuildA $($@_EXTRA_CONFIG)
	cd src/icubuildB; make V=1
	cd src/icubuildB; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la


gdk-pixbuf_VERSION = -2.30.8
gdk-pixbuf:
	$(call extractpatch,$@,$($@_VERSION))
	sed -i~ -e "s; /usr/lib/libgmodule; $(SYSROOT)/usr/lib/libgmodule;" $(SYSROOT)/usr/lib/libgio-2.0.la
	sed -i~ -e "s; /usr/lib/libglib; $(SYSROOT)/usr/lib/libglib;" $(SYSROOT)/usr/lib/libgio-2.0.la
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG) --without-libtiff --without-libtiff gio_can_sniff=yes
	cd src/$@; make V=1
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

nspr_EXTRA_CONFIG = --with-pthreads --with-mozilla
nspr_VERSION = -4.10.7
nspr:
	#$(call extractpatch,$@,$($@_VERSION))
	#cd src/$@/nspr; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	#cd src/$@/nspr/config; gcc -o now.o -c -DXP_UNIX now.c
	#cd src/$@/nspr/config; gcc  now.o   -o now
	#cd src/$@/nspr/config; gcc -o nsinstall.o -c -DXP_UNIX nsinstall.c
	#cd src/$@/nspr/config; gcc  nsinstall.o   -o nsinstall
	cd src/$@/nspr; make
	cd src/$@/nspr; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

libevent_VERSION = -2.0.19-stable
libevent:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la


opus_EXTRA_CONFIG = --disable-static
opus_VERSION = -1.1
libvorbis_EXTRA_CONFIG = --disable-static
libvorbis_VERSION = -1.3.4
libogg_EXTRA_CONFIG = --disable-static
libogg_VERSION = -1.3.2
opus libogg libvorbis:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

libvpx_EXTRA_CONFIG = --prefix=/usr --enable-shared --disable-static --target=generic-gnu
libvpx_VERSION = -v1.3.0
libvpx:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; mkdir -p build 
	cd src/$@/build; STRIP=or1k-linux-musl-strip  CXX=or1k-linux-musl-g++ LD=or1k-linux-musl-gcc CC=or1k-linux-musl-gcc ../configure $($@_EXTRA_CONFIG)
	cd src/$@/build; make V=1
	cd src/$@/build; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la

TiMidity++_VERSION = -2.14.0
TiMidity++_EXTRA_CONFIG = \
--enable-ncurses 	\
--enable-audio=alsa,oss 	\
--disable-alsatest 	\
--disable-esdtest 	\
--disable-aotest 	\
--disable-oggtest	\
--disable-vorbistest	\
--disable-libFLACtest	\
--disable-libOggFLACtest \
--enable-spline=no

TiMidity++:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; lib_cv_va_copy=yes lib_cv___va_copy=yes lib_cv_va_val_copy=yes CFLAGS="-mhard-float -O2" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	-cd src/$@; make
	#cd src/$@/timidity; rm calcnewt.o
	cd src/$@/timidity; gcc calcnewt.c -o calcnewt -lm 
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)


libmikmod_VERSION = -3.3.7
mikmod_VERSION = -3.2.6
libmikmod mikmod:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	echo "#define WORDS_BIGENDIAN 1" >> src/libmikmod/config.h
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la


libsidplayfp_VERSION = -1.5.3
libsidplayfp:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; sed -i~ -e "s;(uint);(unsigned int);" builders/hardsid-builder/hardsid-emu-unix.cpp 
	cd src/$@; CFLAGS="-mhard-float -O2" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	echo "#define WORDS_BIGENDIAN 1" >> src/$@/config.h
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la


sidplayfp_VERSION = -1.3.0
sidplayfp:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; sed -i~ -e "s;PATH_MAX;1024;" src/IniConfig.cpp 
	cd src/$@; CFLAGS="-mhard-float -O2" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	echo "#define WORDS_BIGENDIAN 1" >> src/$@/config.h
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs

htop_EXTRA_CONFIG=--disable-unicode
htop_VERSION = -1.0.3
htop:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

Linux-PAM_VERSION = -1.1.8
Linux-PAM_EXTRA_CONFIG = --sysconfdir=/etc --libdir=/usr/lib
Linux-PAM:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)


node_VERSION = -v0.10.33
node:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; patch -p1 < ../../patches/nodejs/nodejs-nameser_compat.h
	cd src/$@; patch -p1 < ../../patches/nodejs/nodejs-openssl_termios.h
	cd src/$@; patch -p1 < ../../patches/nodejs/nodejs-uv.patch
	cd src/$@; patch -p1 < ../../patches/nodejs/nodejs-uv_ifaddrs.patch
	cd src/$@; patch -p1 < ../../patches/nodejs/nodejs-i386.patch
	cd src/$@; sed -i 's/env python/env python2/' configure
	cd src/$@; find . -type f -name "*.py" -print0 | xargs -r -0 sed -i -e "s;env python;env python2;"
	cd src/$@; CC=or1k-linux-musl-gcc CXX=or1k-linux-musl-g++  LD=or1k-linux-musl-ld ./configure --prefix=/usr --without-snapshot --without-ssl --without-npm --dest-cpu=mips
	cd src/$@; find . -type f -name "*.mk" -print0 | xargs -r -0 sed -i -e "s;-m32;;"
	cd src/$@; make
	#cd src/$@; make install DESTDIR=$(SYSROOT)


ixchat_VERSION = -3.0.2
ixchat:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; $($@_CONF_ENV) ./configure $(CONFIG_HOST)
	#sed -i~ -e "s;lt_sysroot=;lt_sysroot=$(SYSROOT);" src/$@/libtool
	cd src/$@; make CC=or1k-linux-musl-gcc LDFLAGS="-lgmodule-2.0"
	cd src/$@; make install DESTDIR=$(SYSROOT)
	sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;" $(SYSROOT)/usr/lib/*.la


git_VERSION = -2.2.0
git:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ac_cv_snprintf_returns_bogus=yes ac_cv_fread_reads_directories=yes ./configure $(CONFIG_HOST) --with-gitconfig=/etc/gitconfig --with-openssl
	cd src/$@; sed -i 's;XDL_FAST_HASH;NO_XDL_FAST_HASH;' Makefile
	#cd src/$@; sed -i 's;ln \";ln -s \";' Makefile
	cd src/$@; make V=1
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs

bb_EXTRA_CONFIG = --with-aalib-prefix=$(SYSROOT)/usr --disable-aalibtest
bb_VERSION = -1.2
bb:
	#cd src; git clone https://github.com/artyfarty/bb-osx.git
	#cd src; mv bb-osx bb
	cd src/$@; git reset --hard
	cd src/$@; or1k-linux-musl-gcc -mhard-float -o bb -O2 *.c -laa -lcurses
	#$(call extractpatch,$@,$($@_VERSION))
	#cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	#cd src/$@; make
	#cd src/$@; make install DESTDIR=$(SYSROOT)


aalib_EXTRA_CONFIG = --without-x --enable-shared
aalib_VERSION = -1.4.0
aalib:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; cp ../ncurses/config.guess .
	cd src/$@; cp ../ncurses/config.sub .
	cd src/$@; CC=or1k-linux-musl-gcc ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs
	

file_VERSION = -5.20
autoconf_VERSION = -2.69
automake_VERSION = -1.14
m4_VERSION = -1.4.17
m4 file automake autoconf:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs

tcl_VERSION = 8.6.3
tcl_EXTRA_CONFIG = --without-tzdata
tcl:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@/; patch -p1 -i ../../patches/tcl-stat64.patch
	cd src/$@/unix; ac_cv_func_strtod=yes tcl_cv_strtod_buggy=1 ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@/unix; make
	cd src/$@/unix; make install install-private-headers INSTALL_ROOT=$(SYSROOT)



screen_VERSION = -4.2.1
screen_EXTRA_CONFIG = --with-sys-screenrc=/etc/screenrc
screen:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; patch -p1 < ../../patches/screen/screen-root.patch
	cd src/$@; patch -p1 < ../../patches/screen/screen-configure.patch
	cd src/$@; patch -p1 < ../../patches/screen/screen-chmod.patch	
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; echo "#undef UTMPOK" >> config.h
	cd src/$@; echo "#undef LOGINDEFAULT" >> config.h
	cd src/$@; echo "#define LOGINDEFAULT 0" >> config.h
	cd src/$@; echo "#undef GETUTENT" >> config.h
	cd src/$@; echo "#undef UTHOST" >> config.h
	cd src/$@; echo "#undef BUGGYGETLOGIN" >> config.h
	cd src/$@; echo "#undef SOCKDIR" >> config.h
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)


perl_VERSION = -5.20.1
perl:
	#$(call extractpatch,$@,$($@_VERSION))
	cd src; tar -xvzf ../downloads/perl-5.20.1.tar.gz
	cd src; tar -xvjf ../downloads/perl-cross.tar.bz2
	cd src; mv perl-5.20.1 perl
	#cd src/$@; sed -i 's,-fstack-protector,-fnostack-protector,g' ./Configure
	#cd src/$@; sh Configure -des \
	#-Dcc=or1k-linux-musl-gcc	\
	#-Dprefix=/usr		\
	#-Dvendorprefix=/usr	\
	#-Dpager="/usr/bin/less -isR" \
	#-Dinstallprefix="$(SYSROOT)"
	#cd src/$@; make
	cd src/$@; ./configure --prefix=/usr --target=or1k-linux-musl
	cd src/$@; make
	#cd src/$@; make install DESTDIR=$(SYSROOT)

#	-Dusecrosscompile	\
#	-Dtargethost=127.0.0.1	\
#	-Dtargetarch=or1k-linux-musl	\

perl-cross_VERSION =
perl-cross:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)


vim_VERSION = 74
vim_EXTRA_CONFIG = --disable-xsmp --disable-netbeans --disable-acl --with-tlib=ncurses --enable-gui=no --without-x --with-features=small
vim:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; STRIP=or1k-linux-musl-strip vim_cv_memmove_handles_overlap=yes vim_cv_stat_ignores_slash=no vim_cv_getcwd_broken=no vim_cv_tty_group=world vim_cv_terminfo=yes ac_cv_small_wchar_t=yes vim_cv_toupper_broken=no ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)



libcaca_EXTRA_CONFIG = --without-x --disable-cppunit --disable-cxx --disable-network --disable-x11 --enable-ncurses --disable-gl
libcaca_VERSION = -0.99.beta19
libcaca:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs


tmux_EXTRA_CONFIG = --enable-debug
tmux_VERSION = -1.9a
tmux:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs


certs:
	rm -rf src/certs
	mkdir -p src/certs
	cp downloads/certdata.txt src/certs/
	cd src/certs; ../../patches/certs/make-ca.sh
	cd src/certs; ../../patches/certs/remove-expired-certs.sh certs

abiword_VERSION = -3.0.0
abiword:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs



ruby_VERSION = -2.1.5
ruby:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) --enable-shared --disable-install-doc --disable-install-rdoc --without-valgrind
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs

libsigsegv_VERSION = -2.10
libsigsegv:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) --enable-shared --disable-static
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs



gcl_VERSION = -2.6.12
gcl:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) --without-x --disable-ansi
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs

clisp_VERSION = -2.49
clisp:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) --without-ffcall --without-libsigsegv
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs

femtolisp:
	cd src/$@; git reset --hard
	cd src/$@; git clean -f -d -x
	cd src/$@/llt; sed -i "s;error;warning;g" utils.h
	cd src/$@; echo "test:" >> Makefile
	cd src/$@; make CC=or1k-linux-musl-gcc release

Python_VERSION = -2.7.7
Python:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure
	cd src/$@; make python Parser/pgen
	cd src/$@; mv python hostpython
	cd src/$@; mv Parser/pgen Parser/hostpgen
	cd src/$@; make distclean
	cd src/$@; patch -p1 < ../../patches/python/python-xcompile.patch
	cd src/$@; patch -p1 < ../../patches/python/python-includedirs.patch
	cd src/$@; patch -p1 < ../../patches/python/python273-pathsearch.patch
	cd src/$@; ac_cv_file__dev_ptc=yes ac_cv_file__dev_ptmx=yes ./configure --host=or1k-linux-musl --build=or1k --prefix=/usr --enable-shared --with-system-ffi --with-system-expat --without-ensurepip --disable-ipv6
	#cd src/$@; ../../patches/python/patch
	cd src/$@; make HOSTPYTHON=./hostpython HOSTPGEN=./Parser/hostpgen
	cd src/$@; make install DESTDIR=$(SYSROOT)
	make postlibs


php_EXTRA_CONFIG = 			 \
            --sysconfdir=/etc            \
            --localstatedir=/var         \
            --datadir=/usr/share/php     \
            --mandir=/usr/share/man      \
	--disable-all			\
	--disable-rpath			\
            --disable-fpm                 \
            --with-config-file-path=/etc \
            --without-zlib               \
            --disable-bcmath             \
            --without-bz2                \
            --disable-calendar           \
            --enable-dba=shared          \
            --without-gdbm               \
            --without-gmp                \
            --disable-ftp                \
            --without-gettext            \
            --disable-mbstring           \
            --without-readline		\
	--without-curl		\
	--without-freetype	\
	--without-png	\
	--without-jpeg	\
	--without-openssl	\
	--disable-libxml	\
	--disable-dom		\
	--disable-simplexml	\
	--disable-xml		\
	--disable-xmlreader --disable-xmlwriter --without-pear	\
	--without-sqlite3 --disable-pdo --without-pdo-sqlite \
	--disable-phar \
	--enable-opcache=no \
	ac_cv_c_bigendian_php=yes	\
	_cv_have_broken_glibc_fopen_append=no \
	ac_cv_what_readdir_r=POSIX ac_cv_broken_sprintf=no \
	ac_cv_crypt_blowfish=yes ac_cv_crypt_md5=yes ac_cv_crypt_SHA256=yes \
	ac_cv_crypt_SHA512=yes ac_cv_crypt_des=yes ac_cv_crypt_ext_des=yes \
	ac_cv_pwrite=yes ac_cv_pread=yes

php_VERSION = -5.6.3
php:
	#$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install INSTALL_ROOT=$(SYSROOT)
	make postlibs

bsd-games_VERSION = -2.17
bsd-games:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; cp ../../patches/bsdgames/config.params .
	cd src/$@; patch -p1 -i ../../patches/bsdgames/bsd-games-2.17-64bit.patch
	cd src/$@; patch -p1 -i ../../patches/bsdgames/getline.diff
	cd src/$@; patch -p1 -i ../../patches/bsdgames/stdio.h.diff
	cd src/$@; patch -p1 -i ../../patches/bsdgames/gamescreen.h.diff
	cd src/$@; patch -p1 -i ../../patches/bsdgames/number.c.diff
	cd src/$@; patch -p1 -i ../../patches/bsdgames/bad-ntohl-cast.diff
	cd src/$@; patch -p1 -i ../../patches/bsdgames/null-check.diff
	cd src/$@; ./configure
	cd src/$@; make
	#cd src/$@; make CC=or1k-linux-musl-gcc

espeak:
	rm -rf src/$@
	#mkdir -p src/$@
	cd src; unzip ../downloads/espeak-1.48.04-source.zip
	cd src; mv espeak-1.48.04-source espeak

xzgv_VERSION = -0.9.1
xzgv:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; make CC=or1k-linux-musl-gcc


zgv_VERSION = -5.9
zgv:
	#$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; make BACKEND=SDL CC=or1k-linux-musl-gcc

#######################################
# For building a minimal simh sysroot #
#######################################
sysvinit_VERSION = -2.88dsf
heirloom-sh_VERSION = -050706
util-linux_VERSION = -2.27-rc1
libpcap_VERSION = -1.7.4
simh_VERSION = -master
nullmodem_VERSION = -master
coreutils_VERSION = -8.6
uucp_VERSION = -1.07

HISTPROGS = sysvinit heirloom-sh
histprogs: $(HISTPROGS)
histlibs: prelibs $(TOOLCHAIN)
history: fetchhistory histlibs histprogs

sysvinit:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; sed -i -e's/#include <sys\/stat.h>/&\n#define _BSD_SOURCE\n#include <sys\/types.h>\n/' src/mountpoint.c
	cd src/$@; sed -i -e's/#include <sys\/time.h>/&\n#include <sys\/ttydefaults.h>\n/' src/init.c
	cd src/$@; sed -i -e's/#include <syslog.h>/&\n#include <sys\/time.h>\n/' src/wall.c
	#cd src/$@; make -C src CC=$(TOOLCHAIN_TARGET)-gcc
	cd src/$@/src; $(TOOLCHAIN_TARGET)-gcc -ansi -O2 -fomit-frame-pointer -W -Wall -D_GNU_SOURCE -c -o init.o init.c
	cd src/$@/src; $(TOOLCHAIN_TARGET)-gcc -ansi -O2 -fomit-frame-pointer -W -Wall -D_GNU_SOURCE -DINIT_MAIN -c -o init_utmp.o utmp.c
	cd src/$@/src; $(TOOLCHAIN_TARGET)-gcc init.o init_utmp.o -o init
	cd src/$@; $(TOOLCHAIN_TARGET)-strip src/init
	cd src/$@; cp -p src/init $(JOR1KSYSROOT)/
	bzip2 --force --best $(JOR1KSYSROOT)/init

heirloom-sh:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; make CC=$(TOOLCHAIN_TARGET)-gcc
	cd src/$@; $(TOOLCHAIN_TARGET)-strip sh
	cd src/$@; cp -p sh $(JOR1KSYSROOT)/
	bzip2 --force --best $(JOR1KSYSROOT)/sh
	cd src/$@; make clean
	cd src/$@; sed -i -e 's/getopt([[:lower:]]/my&/' bltin.c getopt.c jobs.c ulimit.c
	cd src/$@; sed -i -e 's/malloc([[:lower:]]/my&/' mapmalloc.c
	cd src/$@; sed -i -e 's/[[:space:]]free(/ myfree(/' args.c error.c fault.c func.c io.c jobs.c main.c mapmalloc.c name.c stak.c xec.c
	cd src/$@; sed -i -e 's/^free(/my&/' blok.c mapmalloc.c
	cd src/$@; sed -i -e 's/free[[:space:]]/my&/' defs.h
	cd src/$@; sed -i -e 's/realloc(/my&/' mapmalloc.c
	cd src/$@; make LDFLAGS="-static" CC=$(TOOLCHAIN_TARGET)-gcc
	cd src/$@; $(TOOLCHAIN_TARGET)-strip sh
	cd src/$@; cp -p sh $(JOR1KSYSROOT)/sh.static
	bzip2 --force --best $(JOR1KSYSROOT)/sh.static

fetchhistory:
	wget -nc -P downloads/ http://download.savannah.gnu.org/releases/sysvinit/sysvinit$(sysvinit_VERSION).tar.bz2
	wget -nc -P downloads/ http://sourceforge.net/projects/heirloom/files/heirloom-sh/050706/heirloom-sh$(heirloom-sh_VERSION).tar.bz2
#        wget -nc -P downloads/ https://www.kernel.org/pub/linux/utils/util-linux/v2.27/util-linux$(util-linux_VERSION).tar.gz
#        wget -nc -P downloads/ http://www.tcpdump.org/release/libpcap$(libpcap_VERSION).tar.gz
#        wget -nc -O downloads/simh-master.tar.gz https://github.com/simh/simh/archive/master.tar.gz || ls downloads/simh-master.tar.gz >/dev/null
#        wget -nc -O downloads/nullmodem-master.tar.gz https://github.com/dugoh/nullmodem/archive/master.zip || ls downloads/simh-master.tar.gz >/dev/null
#        wget -nc -P downloads/ ftp://ftp.gnu.org/gnu/coreutils/coreutils$(coreutils_VERSION).tar.gz
#        wget -nc -P downloads/ ftp://ftp.gnu.org/gnu/uucp/uucp$(uucp_VERSION).tar.gz
