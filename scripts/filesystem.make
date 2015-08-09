RAMFS=$(PWD)/hd

packages:						\
uclibcfs busyboxfs ncursesfs zlibfs 			\
binutilsfs gccfs nanofs joefs linux-headersfs		\
bcfs makefs expatfs lynxfs opensshfs 			\
libpngfs libjpeg-turbofs pixmanfs			\
freetypefs tslibfs nmapfs SDLfs				\
scummvmfs opensslfs 				\
curlfs sdldoomfs			\
libffifs

preparefs:
	mkdir -p hd
	rm -rf $(RAMFS)/*

finishfs:
	cd $(RAMFS); find . -name "*.la" -exec rm {} \;
	rm -f  $(RAMFS)/usr/lib/*.la
	rm -f  $(RAMFS)/usr/lib/*.la~
	rm -f  $(RAMFS)/usr/lib/*.py
ifndef noremovearchive
	rm -f  $(RAMFS)/usr/lib/*.a
endif
	rm -rf  $(RAMFS)/usr/lib/pkgconfig
	rm -rf  $(RAMFS)/usr/lib/locale
	rm -rf  $(RAMFS)/usr/share/pkgconfig
	rm -rf  $(RAMFS)/usr/share/doc
	rm -rf  $(RAMFS)/usr/share/info
	rm -rf  $(RAMFS)/usr/info
	rm -rf  $(RAMFS)/usr/share/man
	rm -rf  $(RAMFS)/usr/share/locale
	rm -rf  $(RAMFS)/usr/share/gtk-doc
	rm -rf  $(RAMFS)/usr/man
	#rm -rf  $(RAMFS)/lib/udev
	rm -rf  $(RAMFS)/usr/share/applications
	rm -rf  $(RAMFS)/usr/share/pixmaps
	#rm -rf  $(RAMFS)/usr/etc
	rm -rf  $(RAMFS)/usr/share/aclocal
	find $(RAMFS) -type f -executable -exec $(TOOLCHAIN_TARGET)-strip --strip-unneeded {} \;
ifndef noremove
	find $(RAMFS) -type d -empty -delete
endif
	if [ -d "hd/usr/include" ]; then cd hd; tar -cvjf ../bin/$(FILENAME)-dev.tar.bz2 usr/include/ ; fi
	cd hd; tar --exclude=usr/include -cvjf ../bin/$(FILENAME).tar.bz2 *

basefs:
	make preparefs
	mkdir -p -m 755 $(RAMFS)/home
	mkdir -p -m 555 $(RAMFS)/proc
	mkdir -p -m 755 $(RAMFS)/dev
	mkdir -p -m 755 $(RAMFS)/sys
	mkdir -p -m 755 $(RAMFS)/etc
	mkdir -p -m 755 $(RAMFS)/etc/init.d
	mkdir -p -m 755 $(RAMFS)/etc/network
	mkdir -p -m 777 $(RAMFS)/sbin
	mkdir -p -m 1777 $(RAMFS)/tmp
	mkdir -p -m 555 $(RAMFS)/root
	mkdir -p -m 555 $(RAMFS)/lib
	mkdir -p -m 755 $(RAMFS)/usr
	mkdir -p -m 755 $(RAMFS)/var
	mkdir -p -m 777 $(RAMFS)/var/run
	mkdir -p -m 755 $(RAMFS)/var/empty
	mkdir -p -m 755 $(RAMFS)/usr/bin
	mkdir -p -m 755 $(RAMFS)/usr/include
	mkdir -p -m 755 $(RAMFS)/usr/lib
	mkdir -p -m 755 $(RAMFS)/usr/share
	mkdir -p -m 755 $(RAMFS)/usr/share/udhcpc
	mkdir -p -m 777 $(RAMFS)/usr/sbin
	mkdir -p -m 755 $(RAMFS)/usr/libexec
	cp -P patches/init/root/.profile $(RAMFS)/root/
	cp -P patches/init/usr/share/udhcpc/default.script $(RAMFS)/usr/share/udhcpc/
	cp -P patches/init/etc/fstab $(RAMFS)/etc/
	cp -P patches/init/etc/host.conf $(RAMFS)/etc/
	cp -P patches/init/etc/inetd.conf $(RAMFS)/etc/
	cp -P patches/init/etc/inittab $(RAMFS)/etc/
	cp -P patches/init/etc/network/interfaces $(RAMFS)/etc/network
	cp -P patches/init/etc/nsswitch.conf $(RAMFS)/etc/
	cp -P patches/init/etc/passwd $(RAMFS)/etc/
	cp -P patches/init/etc/services $(RAMFS)/etc/
	cp -P patches/init/etc/init.d/rcS $(RAMFS)/etc/init.d
	#cp -Pr patches/init/* $(RAMFS)/
	make finishfs FILENAME=base noremove=1

busyboxfs:
	make preparefs
	cd src/busybox; make CONFIG_PREFIX=$(RAMFS) install
	make finishfs FILENAME=busybox

ncursesfs:
	make preparefs
	cd src/ncurses; make install DESTDIR=$(RAMFS)
	cp src/ncurses/test/blue $(RAMFS)/usr/bin/
	cp src/ncurses/test/bs $(RAMFS)/usr/bin/
	cp src/ncurses/test/firework $(RAMFS)/usr/bin/
	cp src/ncurses/test/gdc $(RAMFS)/usr/bin/
	cp src/ncurses/test/hanoi $(RAMFS)/usr/bin/
	cp src/ncurses/test/knight $(RAMFS)/usr/bin/
	cp src/ncurses/test/lrtest $(RAMFS)/usr/bin/
	cp src/ncurses/test/ncurses $(RAMFS)/usr/bin/
	cp src/ncurses/test/newdemo $(RAMFS)/usr/bin/
	cp src/ncurses/test/rain $(RAMFS)/usr/bin/
	cp src/ncurses/test/tclock $(RAMFS)/usr/bin/
	cp src/ncurses/test/testcurs $(RAMFS)/usr/bin/
	cp src/ncurses/test/worm $(RAMFS)/usr/bin/
	cp src/ncurses/test/xmas $(RAMFS)/usr/bin/
	make finishfs FILENAME=ncurses

gccfs:
	make preparefs
	cd src/gcc-nativebuild; make DESTDIR=$(RAMFS) install-strip
	rm -rf  $(RAMFS)/usr/lib/libgcc*
	rm -rf  $(RAMFS)/usr/lib/libstdc++*
	rm -rf  $(RAMFS)/usr/bin/or1k-linux*
	rm -rf  $(RAMFS)/usr/share
	#rm -rf  $(RAMFS)/usr/include
	#rm -f  $(RAMFS)/usr/bin/cpp
	#rm -rf  $(RAMFS)/usr/lib
	#rm -rf  $(RAMFS)/usr/or1k-linux
	make finishfs FILENAME=gcc

binutilsfs:
	make preparefs
	cd src/build-or1k-src; STRIPPROG="$(TOOLCHAIN_TARGET)-strip" make tooldir=/usr DESTDIR=$(RAMFS) install
	#rm -rf  $(RAMFS)/usr/share
	rm -rf  $(RAMFS)/usr/include
	#rm -rf  $(RAMFS)/usr/lib
	#rm -rf  $(RAMFS)/usr/or1k-linux
	make finishfs FILENAME=binutils


zlibfs:
	make preparefs
	cd src/zlib; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=zlib

nanofs:
	make preparefs
	#mkdir -p $(RAMFS)/etc
	#cp patches/nanorc $(RAMFS)/etc/
	cd src/nano; make install DESTDIR=$(RAMFS)
	ln -s nano $(RAMFS)/usr/bin/pico
	rm -rf $(RAMFS)/usr/share
	make finishfs FILENAME=nano

joefs:
	make preparefs
	cd src/joe; make install DESTDIR=$(RAMFS)
	rm -rf $(RAMFS)/usr/share/joe/lang
	rm -rf $(RAMFS)/usr/share/joe/charmaps
	make finishfs FILENAME=joe

uclibcfs:
	make preparefs
	mkdir -p $(RAMFS)/usr/bin
	cd src/uClibc-or1k; make PREFIX=$(RAMFS) install
	ln -f -s ld-uClibc.so.0 $(RAMFS)/lib/ld.so.1
	cp src/uClibc-or1k/utils/ldd $(RAMFS)/usr/bin/
	make finishfs FILENAME=uclibc

linux-headersfs:
	make preparefs
	cd src/linux/; make ARCH=openrisc INSTALL_HDR_PATH=${RAMFS}/usr headers_install
	make finishfs FILENAME=linux-headers

bcfs:
	make preparefs
	cd src/bc; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=bc

makefs:
	make preparefs
	cd src/make; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=make

expatfs:
	make preparefs
	cd src/expat; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=expat

lynxfs:
	make preparefs
	cd src/lynx; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=lynx

opensshfs:
	make preparefs
	cd src/openssh; make install DESTDIR=$(RAMFS)
	mkdir -p $(RAMFS)/etc/ssh
	ssh-keygen -f $(RAMFS)/etc/ssh/ssh_host_rsa_key -N "" -t rsa
	ssh-keygen -f $(RAMFS)/etc/ssh/ssh_host_dsa_key -N "" -t dsa
	ssh-keygen -f $(RAMFS)/etc/ssh/ssh_host_ecdsa_key -N "" -t ecdsa
	ssh-keygen -f $(RAMFS)/etc/ssh/ssh_host_ed25519_key -N "" -t ed25519
	chmod u+s $(RAMFS)/usr/sbin/sshd
	make finishfs FILENAME=openssh

libpngfs:
	make preparefs
	cd src/libpng; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=libpng

libjpeg-turbofs:
	make preparefs
	cd src/libjpeg-turbo; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=libjpeg-turbo

pixmanfs:
	make preparefs
	cd src/pixman; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=pixman

freetypefs:
	make preparefs
	cd src/freetype; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=freetype


tslibfs:
	make preparefs
	cd src/tslib; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "/relink/d"
	mkdir -p $(RAMFS)/etc
	cd src/tslib; make install DESTDIR=$(RAMFS)
	cd $(RAMFS)/usr/lib/ts; find . -type 'f' | grep -v "input.so" | xargs rm 
	cp patches/init/etc/ts.conf $(RAMFS)/etc/
	cp patches/init/etc/pointercal $(RAMFS)/etc/
	make finishfs FILENAME=tslib

nmapfs:
	make preparefs
	cd src/nmap; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=nmap

alsafs:
	make preparefs
	cd src/alsa-lib; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "/relink/d"
	cd src/alsa-lib; make install DESTDIR=$(RAMFS)
	rm -rf $(RAMFS)/usr/share/alsa/ucm/ 
	find $(RAMFS)/usr/share/alsa/cards/ ! -name "aliases.conf" -exec rm -f {} \;
	find $(RAMFS)/usr/share/alsa/pcm/ ! -name "d*.conf" -exec rm -f {} \;
	make finishfs FILENAME=alsa

alsa-utilsfs:
	make preparefs
	cd src/alsa-utils; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=alsa-utils



SDLfs:
	make preparefs
	cd src/SDL; make install DESTDIR=$(RAMFS)
	cd src/SDL_mixer; make install DESTDIR=$(RAMFS)
	cd src/SDL_image; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=SDL

SDL2fs:
	make preparefs
	cd src/SDL2; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=SDL2

scummvmfs:
	make preparefs
	cd src/scummvm; make install DESTDIR=$(RAMFS)
	chmod u+s $(RAMFS)/usr/bin/scummvm
	make finishfs FILENAME=scummvm

opensslfs:
	make preparefs
	cd src/openssl; make INSTALL_PREFIX=$(RAMFS) install
	#$(TOOLCHAIN_TARGET)-ranlib $(RAMFS)/usr/lib/libssl.a
	#$(TOOLCHAIN_TARGET)-ranlib $(RAMFS)/usr/lib/libcrypt.a
	rm -rf $(RAMFS)/etc/ssl/man
	#rm -rf $(RAMFS)/usr/include
	make finishfs FILENAME=openssl

certsfs:
	make preparefs
	install -d $(RAMFS)/etc/ssl/certs
	cp -v src/certs/certs/*.pem $(RAMFS)/etc/ssl/certs/
	./patches/certs/c_rehash $(RAMFS)/etc/ssl/certs/
	install src/certs/BLFS-ca-bundle-*.crt $(RAMFS)/etc/ssl/ca-bundle.crt
	ln -sfv ../ca-bundle.crt $(RAMFS)/etc/ssl/certs/ca-certificates.crt
	make finishfs FILENAME=certs



directfbfs:
	make preparefs
	#cd src/DirectFB/interfaces; find . -name "*.la" -exec sed -i~ -e "/relink/d" {} \;
	#cd src/DirectFB/interfaces; find . -name "*.la" -exec rm {} \;
	#sed -i~ -e "/relink/d" src/DirectFB/lib/fusion/libfusion.la
	#sed -i~ -e "/relink/d" src/DirectFB/src/libdirectfb.la
	#sed -i~ -e "/relink/d" src/DirectFB/systems/dummy/libdirectfb_dummy.la
	#sed -i~ -e "/relink/d" src/DirectFB/systems/devmem/libdirectfb_devmem.la
	#sed -i~ -e "/relink/d" src/DirectFB/systems/fbdev/libdirectfb_fbdev.la
	#sed -i~ -e "/relink/d" src/DirectFB/wm/default/libdirectfbwm_default.la
	#sed -i~ -e "/relink/d" src/DirectFB/interfaces/ICoreResourceManager/libicoreresourcemanager_test.la
	#sed -i~ -e "/relink/d" src/DirectFB/interfaces/IDirectFBFont/libidirectfbfont_dgiff.la
	#sed -i~ -e "/relink/d" src/DirectFB/interfaces/IDirectFBImageProvider/libidirectfbimageprovider_dfiff.la
	cd src/DirectFB; make install DESTDIR=$(RAMFS)
	mkdir -p $(RAMFS)/etc
	cp patches/init/etc/directfbrc $(RAMFS)/etc/
	make finishfs FILENAME=directfb

DirectFB-examplesfs:
	make preparefs
	cd src/DirectFB-examples; make install DESTDIR=$(RAMFS)
	chmod u+s $(RAMFS)/usr/bin/df_*
	or1k-linux-musl-gcc -Ofast patches/code/fbdemo.c -o $(RAMFS)/usr/bin/fbdemo
	cd src/fire; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=DirectFB-examples

curlfs:
	make preparefs
	cd src/curl; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=curl

sdldoomfs:
	make preparefs
	mkdir -p $(RAMFS)/home/user
	cd src/sdldoom; make install DESTDIR=$(RAMFS)
	chmod u+s $(RAMFS)/usr/bin/doom
	cp downloads/doom1* $(RAMFS)/home/user
	cd $(RAMFS); chown -R 1000:1000 home/user
	make finishfs FILENAME=sdldoom

freerafs:
	make preparefs
	mkdir -p $(RAMFS)/usr/share/games/freera
	cd src/freera++; cp freera $(RAMFS)/usr/share/games/freera/
	cd src/freera++; cp -r data $(RAMFS)/usr/share/games/freera/
	sed -i~ -e "s;480;400;" src/freera++/data/settings/freecnc.ini
	chmod u+s $(RAMFS)/usr/share/games/freera/freera
	cp downloads/ra/* $(RAMFS)/usr/share/games/freera/data/mix/
	make finishfs FILENAME=freera

prboomfs:
	make preparefs
	#mkdir -p $(RAMFS)/home/user
	mkdir -p $(RAMFS)/usr/bin
	cd src/prboom; make install DESTDIR=$(RAMFS)
	mv $(RAMFS)/usr/games/prboom $(RAMFS)/usr/bin/
	chmod u+s $(RAMFS)/usr/bin/prboom
	rm -rf  $(RAMFS)/usr/games
	cp downloads/doom1* $(RAMFS)/usr/share/games/doom
	#cd $(RAMFS); chown -R 1000:1000 home/user
	make finishfs FILENAME=prboom

libffifs:
	make preparefs
	cd src/libffi; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=libffi

dunefs:
	make preparefs
	cd src/dunelegacy; make install DESTDIR=$(RAMFS)
	cp downloads/dune2/*.PAK $(RAMFS)/usr/share/dunelegacy/
	make finishfs FILENAME=dune

waylandfs:
	make preparefs
	cd src/wayland; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "/relink/d"
	cd src/wayland; find . -type f -name "*.lai" -print0 | xargs -r -0 sed -i -e "/relink/d"
	find src/wayland -name "*.la" -exec sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;g" {} \;
	find src/wayland -name "*.la" -exec sed -i~ -e "s;dependency_libs=' /usr;dependency_libs=' $(SYSROOT)/usr;g" {} \;
	find src/wayland -name "*.la" -exec sed -i~ -e "s; /usr; $(SYSROOT)/usr;g" {} \;
	find src/wayland -name "*.lai" -exec sed -i~ -e "s;libdir='/usr;libdir='$(SYSROOT)/usr;g" {} \;
	find src/wayland -name "*.lai" -exec sed -i~ -e "s;dependency_libs=' /usr;dependency_libs=' $(SYSROOT)/usr;g" {} \;
	find src/wayland -name "*.lai" -exec sed -i~ -e "s; /usr; $(SYSROOT)/usr;g" {} \;
	cd src/wayland; make install DESTDIR=$(RAMFS) V=1
	make finishfs FILENAME=wayland

libevdevfs:
	make preparefs
	cd src/libevdev; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=libevdev

libinputfs:
	make preparefs
	cd src/libinput; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=libinput


westonfs:
	make preparefs
	#cd src/wayland; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "/relink/d"
	cd src/weston; make install DESTDIR=$(RAMFS)
	cp src/weston/weston-flower $(RAMFS)/usr/bin/
	cp src/weston/weston-simple-shm $(RAMFS)/usr/bin/
	cp src/weston/weston-calibrator $(RAMFS)/usr/bin/
	mkdir -p $(RAMFS)/root/.config
	cp patches/weston.ini $(RAMFS)/root/.config/
	mkdir -p $(RAMFS)/home/user/.config
	cp patches/weston.ini $(RAMFS)/home/user/.config/
	#----
	#mkdir -p $(RAMFS)/tmp/root-runtime-dir
	#chmod 0700 $(RAMFS)/tmp/root-runtime-dir
	echo "/sbin/udevadm test /devices/93000000.tsc/input/input1/event1" > $(RAMFS)/usr/bin/startweston
	echo "mkdir -p /tmp/root-runtime-dir" >> $(RAMFS)/usr/bin/startweston
	echo "mount -t tmpfs tmpfs /tmp/root-runtime-dir" >> $(RAMFS)/usr/bin/startweston
	echo "chmod 0700 /tmp/root-runtime-dir" >> $(RAMFS)/usr/bin/startweston
	echo "export XDG_RUNTIME_DIR=/tmp/root-runtime-dir" >> $(RAMFS)/usr/bin/startweston
	echo "weston --backend=fbdev-backend.so --tty=2" >> $(RAMFS)/usr/bin/startweston
	#----
	chmod a+rx $(RAMFS)/usr/bin/startweston
	#chmod u+s $(RAMFS)/usr/bin/startweston	
	chmod u+s $(RAMFS)/usr/bin/weston
	#cd $(RAMFS); chown -R 1000:1000 home/user
	#cd $(RAMFS); chown -R 1000:1000 home/user/.config
	cp -prf patches/weston/* $(RAMFS)/usr/share/
	make finishfs FILENAME=weston

libxkbcommonfs:
	make preparefs
	cd src/libxkbcommon; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=libxkbcommon


eudevfs:
	make preparefs
	cd src/eudev; make install DESTDIR=$(RAMFS)
	echo 'SUBSYSTEM=="input", ATTRS{name}=="ts-lpc32xx", ENV{WL_CALIBRATION}="1.6 0 0 0 2.6 0"' > $(RAMFS)/lib/udev/rules.d/900-tsc-calibration.rules
	make finishfs FILENAME=eudev

libdrmfs:
	make preparefs
	cd src/libdrm; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "/relink/d"
	cd src/libdrm; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=libdrm

mtdevfs:
	make preparefs
	cd src/mtdev; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=mtdev


stracefs:
	make preparefs
	cd src/strace; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=strace

muslfs:
	make preparefs
	cd src/musl; make install DESTDIR=$(RAMFS)
	mkdir -p $(RAMFS)/usr/bin
	cd $(RAMFS)/usr/bin; ln -s /usr/lib/libc.so ldd
	rm $(RAMFS)/usr/lib/libc.a
	or1k-linux-musl-gcc -O2 patches/code/getconf.c -o $(RAMFS)/usr/bin/getconf
	make finishfs FILENAME=musl noremovearchive=1


gcc-libsfs:
	make preparefs
	mkdir -p $(RAMFS)/usr/lib
	#cp -P $(TOOLCHAIN_DIR)/$(TOOLCHAIN_TARGET)/lib/libgcc* $(RAMFS)/usr/lib/
	#cp -P $(TOOLCHAIN_DIR)/$(TOOLCHAIN_TARGET)/lib/libstdc++.so* $(RAMFS)/usr/lib/
	#cp -P /opt/cross2/or1k-linux-musl/$(TOOLCHAIN_TARGET)/lib/libgcc* $(RAMFS)/usr/lib/
	#cp -P /opt/cross2/or1k-linux-musl/$(TOOLCHAIN_TARGET)/lib/libstdc++.so* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libgcc* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libstdc++.so* $(RAMFS)/usr/lib/
	make finishfs FILENAME=gcc-libs

luafs:
	make preparefs
	cd src/lua; make INSTALL_TOP=$(RAMFS)/usr TO_LIB="liblua.so liblua.so.5.2 liblua.so.5.2.3" INSTALL_DATA="cp -d" install
	make finishfs FILENAME=lua


dosboxfs:
	make preparefs
	cd src/dosbox; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=dosbox 

Frodofs:
	make preparefs
	mkdir -p $(RAMFS)/usr/bin
	cp src/Frodo/Frodo $(RAMFS)/usr/bin
	cp src/Frodo/FrodoSC $(RAMFS)/usr/bin
	cp src/Frodo/FrodoPC $(RAMFS)/usr/bin
	make finishfs FILENAME=Frodo 


monkeyfs:
	make preparefs
	mkdir -p $(RAMFS)/home/user
	mkdir -p $(RAMFS)/usr/share/games
	cp -P patches/scummvmrc $(RAMFS)/home/user/.scummvmrc
	mkdir -p $(RAMFS)/usr/share/games/monkey
	cp -r downloads/monkey/* $(RAMFS)/usr/share/games/monkey/
	cd $(RAMFS); chown -R 1000:1000 home/user
	make finishfs FILENAME=monkey


nbenchfs:
	make preparefs
	mkdir -p $(RAMFS)/usr/bin
	mkdir -p $(RAMFS)/usr/share/nbench
	cp src/nbench-byte/nbench $(RAMFS)/usr/bin/
	cp src/nbench-byte/NNET.DAT $(RAMFS)/usr/share/nbench/
	cp src/coremark/coremark.exe $(RAMFS)/usr/bin/coremark
	make finishfs FILENAME=nbench

mplayerfs:
	make preparefs
	cd src/MPlayer; make install DESTDIR=$(RAMFS)
	mkdir -p $(RAMFS)/usr/share/mplayer
	cp downloads/orion_1.mpg $(RAMFS)/usr/share/mplayer/
	cp ~/videoconvert/Mandelbulb_Flight.3gp  $(RAMFS)/usr/share/mplayer/
	#cp ~/videoconvert/taipei.avi $(RAMFS)/usr/share/mplayer/
	make finishfs FILENAME=mplayer

linksfs:
	make preparefs
	cd src/links; make install DESTDIR=$(RAMFS)
	chmod u+s $(RAMFS)/usr/bin/links
	make finishfs FILENAME=links

frotzfs:
	make preparefs
	mkdir -p $(RAMFS)/usr/bin
	mkdir -p $(RAMFS)/usr/share/frotz
	cp src/frotz/frotz $(RAMFS)/usr/bin/
	cp patches/905.z5 $(RAMFS)/usr/share/frotz/
	make finishfs FILENAME=frotz

xeyesfs:
	make preparefs
	cd src/xeyes/; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=xeyes

xcalcfs:
	make preparefs
	cd src/xcalc/; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=xcalc

twmfs:
	make preparefs
	cd src/twm/; make install DESTDIR=$(RAMFS)
	cp -rf patches/twm $(RAMFS)/usr/share/X11/
	make finishfs FILENAME=twm

fluxboxfs:
	make preparefs
	cd src/fluxbox/; make install DESTDIR=$(RAMFS)
	cd src/xmodmap; make install DESTDIR=$(RAMFS)
	cd $(RAMFS)/usr/share/fluxbox/nls; rm -rf *UTF-8
	cd $(RAMFS)/usr/share/fluxbox/nls; rm -rf *ISO-8859*
	cd $(RAMFS)/usr/share/fluxbox/nls; rm -rf *BIG5*
	cd $(RAMFS)/usr/share/fluxbox/nls; rm -rf *KOI8*
	cd $(RAMFS)/usr/share/fluxbox/nls; rm -rf *GB*
	cd $(RAMFS)/usr/share/fluxbox/nls; rm -rf *EUC*
	cd $(RAMFS)/usr/share/fluxbox/nls; rm -rf *JP*
	cd $(RAMFS)/usr/share/fluxbox/nls; rm -rf *CP*
	mkdir -p $(RAMFS)/home/user/.fluxbox
	cp -v $(RAMFS)/usr/share/fluxbox/init $(RAMFS)/home/user/.fluxbox/init
	cp -v $(RAMFS)/usr/share/fluxbox/keys $(RAMFS)/home/user/.fluxbox/keys
	cp -v $(RAMFS)/usr/share/fluxbox/menu $(RAMFS)/home/user/.fluxbox/menu
	cd $(RAMFS); chown -R 1000:1000 home/user
	make finishfs FILENAME=fluxbox noremove=1

xtermfs:
	make preparefs
	cd src/xterm/; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=xterm

xsetrootfs:
	make preparefs
	cd src/xsetroot/; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=xsetroot

xclockfs:
	make preparefs
	cd src/xclock/; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=xclock

xinitfs:
	make preparefs
	#cd src/xinit/; make install DESTDIR=$(RAMFS)
	mkdir -p $(RAMFS)/usr/bin
	mkdir -p $(RAMFS)/etc
	echo "xli -onroot /usr/share/X11/twm/walls/bg.jpg" > $(RAMFS)/etc/xinitrc
	echo "twm" >> $(RAMFS)/etc/xinitrc
	#ln -s $(RAMFS)/usr/bin/X Xfbdev
	#chmod a+rx $(RAMFS)/usr/bin/X
	cp patches/startx $(RAMFS)/usr/bin/
	cp src/xinit/xinit $(RAMFS)/usr/bin/
	cp src/xli/xli $(RAMFS)/usr/bin/
	chmod a+rx $(RAMFS)/usr/bin/startx
	chmod a+rx $(RAMFS)/usr/bin/xinit
	make finishfs FILENAME=xinit

xorg-serverfs:
	make preparefs
	cd src/xorg-server; make install DESTDIR=$(RAMFS)
	chmod u+s $(RAMFS)/usr/bin/Xfbdev
	make finishfs FILENAME=xorg-server

glxgearsfs:
	make preparefs
	cd src/Mesa; make -C xdemos DEMOS_PREFIX=/usr DESTDIR=$(RAMFS) install
	make finishfs FILENAME=glxgears

topplerfs:
	make preparefs
	cd src/toppler; make DESTDIR=$(RAMFS) install
	chmod u+s $(RAMFS)/usr/bin/toppler
	rm -rf $(RAMFS)/usr/share/games/toppler/applications
	rm -rf $(RAMFS)/usr/share/games/toppler/man
	rm -rf $(RAMFS)/usr/share/games/toppler/doc
	mkdir -p $(RAMFS)/home/user/.toppler
	cd $(RAMFS); chown -R 1000:1000 home/user
	or1k-linux-musl-gcc -Ofast patches/code/fbdemo.c -o $(RAMFS)/usr/bin/fbdemo
	make finishfs FILENAME=toppler noremove=1

quakefs:
	make preparefs
	mkdir -p $(RAMFS)/usr/bin/
	cd src/quakeforge; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "/relink/d"
	cd src/quakeforge; make install DESTDIR=$(RAMFS)
	#cp src/quakespasm/Quake/quakespasm $(RAMFS)/usr/bin/
	#cp src/tyrquake/tyr-glquake $(RAMFS)/usr/bin/
	#cp src/tyrquake/tyr-glqwcl $(RAMFS)/usr/bin/
	#cp src/tyrquake/tyr-quake $(RAMFS)/usr/bin/
	#cp src/tyrquake/tyr-qwcl $(RAMFS)/usr/bin/
	#cp src/tyrquake/tyr-qwsv $(RAMFS)/usr/bin/
	mkdir -p $(RAMFS)/usr/share/games/quakeforge/id1
	cp -f downloads/quake/ID1/PAK0.PAK $(RAMFS)/usr/share/games/quakeforge/id1/pak0.pak
	cp -f downloads/quake/ID1/CONFIG.CFG $(RAMFS)/usr/share/games/quakeforge/id1/config.cfg
	make finishfs FILENAME=quake

xkbcompfs:
	make preparefs
	#cd src/xkbcomp; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "/relink/d"
	cd src/xkbcomp; make install DESTDIR=$(RAMFS)
	cd src/xkeyboard-config/; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=xkbcomp

mesafs:
	make preparefs
	cd src/Mesa; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=mesa

mesa-demosfs:
	make preparefs
	cd src/mesa-demos; make install DESTDIR=$(RAMFS)
	cd src/glew; make install GLEW_DEST=$(RAMFS)/usr LIBDIR=$(RAMFS)/usr/lib
	cd src/freeglut; make install DESTDIR=$(RAMFS)
	cd src/libXi/; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=mesa-demos

fontfs:
	make preparefs
	cd src/font-util/; make install DESTDIR=$(RAMFS)
	#cd src/encodings/; make install DESTDIR=$(RAMFS)
	mkdir -p $(RAMFS)/var/cache/fontconfig
	mkdir -p $(RAMFS)/usr/share/fonts/X11
	mkdir -p $(RAMFS)/usr/share/fonts/X11/misc
	mkdir -p $(RAMFS)/usr/share/fonts/X11/TTF
	mkdir -p $(RAMFS)/usr/share/fonts/X11/OTF
	mkdir -p $(RAMFS)/usr/share/fonts/X11/Type1
	mkdir -p $(RAMFS)/usr/share/fonts/X11/100dpi
	mkdir -p $(RAMFS)/usr/share/fonts/X11/75dpi
	printf "0\n" >> $(RAMFS)/usr/share/fonts/X11/misc/fonts.dir
	printf "0\n" >> $(RAMFS)/usr/share/fonts/X11/TTF/fonts.dir
	printf "0\n" >> $(RAMFS)/usr/share/fonts/X11/OTF/fonts.dir
	printf "0\n" >> $(RAMFS)/usr/share/fonts/X11/Type1/fonts.dir
	printf "0\n" >> $(RAMFS)/usr/share/fonts/X11/100dpi/fonts.dir
	printf "0\n" >> $(RAMFS)/usr/share/fonts/X11/75dpi/fonts.dir
	cp patches/luxisr.ttf $(RAMFS)/usr/share/fonts/X11/TTF/
	#cd src/font-bh-75dpi/; make install DESTDIR=$(RAMFS)
	#cd src/font-bh-ttf/; make install DESTDIR=$(RAMFS)
	#cd src/font-adobe-75dpi/; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=font


fontconfigfs:
	make preparefs
	cd src/fontconfig/; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=fontconfig


libX11fs:
	make preparefs
	cd src/libXau/; make install DESTDIR=$(RAMFS)
	cd src/libXdmcp/; make install DESTDIR=$(RAMFS)
	cd src/libXfixes/; make install DESTDIR=$(RAMFS)
	cd src/libXxf86dga/; make install DESTDIR=$(RAMFS)
	cd src/libXxf86vm/; make install DESTDIR=$(RAMFS)
	cd src/libXinerama/; make install DESTDIR=$(RAMFS)
	cd src/libXrandr/; make install DESTDIR=$(RAMFS)
	cd src/libXcursor/; make install DESTDIR=$(RAMFS)
	cd src/glu/; make install DESTDIR=$(RAMFS)
	cd src/libXext/; make install DESTDIR=$(RAMFS)
	cd src/libICE/; make install DESTDIR=$(RAMFS)
	cd src/libSM/; make install DESTDIR=$(RAMFS)
	cd src/libXrender/; make install DESTDIR=$(RAMFS)
	cd src/libXt/; make install DESTDIR=$(RAMFS)
	cd src/libXmu/; make install DESTDIR=$(RAMFS)
	cd src/libxkbfile/; make install DESTDIR=$(RAMFS)
	cd src/libfontenc/; make install DESTDIR=$(RAMFS)
	cd src/libXfont/; make install DESTDIR=$(RAMFS)
	cd src/libXft/; make install DESTDIR=$(RAMFS)
	cd src/libXaw/; make install DESTDIR=$(RAMFS)
	cd src/libXpm/; make install DESTDIR=$(RAMFS)
	cd src/libXcomposite/; make install DESTDIR=$(RAMFS)
	cd src/libXdamage/; make install DESTDIR=$(RAMFS)
	cd src/libXfixes/; make install DESTDIR=$(RAMFS)
	#cd src/libXss/; make install DESTDIR=$(RAMFS)
	cd src/libXv/; make install DESTDIR=$(RAMFS)
	cd src/libX11; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "/relink/d"
	cd src/libX11; patch < ../../patches/libool_norelink.patch
	cd src/libX11/; make install DESTDIR=$(RAMFS)
	cd src/libxcb; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "/relink/d"
	cd src/libxcb; patch < ../../patches/libool_norelink.patch
	cd src/libxcb/; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=libX11


d1xfs:
	make preparefs
	 cd src/physfs/build; cmake .. \
	-DCMAKE_TOOLCHAIN_FILE=../../../patches/CMake_Cross_Compiling   \
	-DCMAKE_INSTALL_PREFIX=$(RAMFS)/usr
	cd src/physfs/build; make
	cd src/physfs/build; make install
	mkdir -p $(RAMFS)/usr/bin
	cp src/d1x-rebirth/d1x-rebirth $(RAMFS)/usr/bin
	chmod u+s $(RAMFS)/usr/bin/d1x-rebirth
	mkdir -p $(RAMFS)/usr/share/d1x-rebirth/
	cd $(RAMFS)/usr/share/d1x-rebirth/; unzip ../../../../downloads/descent-pc-shareware.zip
	mkdir -p $(RAMFS)/home/user/.d1x-rebirth
	cd $(RAMFS); chown -R 1000:1000 home/user
	echo "ResolutionY=400" > $(RAMFS)/home/user/.d1x-rebirth/descent.cfg
	echo "ResolutionX=640" >> $(RAMFS)/home/user/.d1x-rebirth/descent.cfg
	echo "VSync=0" >> $(RAMFS)/home/user/.d1x-rebirth/descent.cfg
	echo "TexFilt=0" >> $(RAMFS)/home/user/.d1x-rebirth/descent.cfg
	echo "FPSIndicator=1" >> $(RAMFS)/home/user/.d1x-rebirth/descent.cfg
	make finishfs FILENAME=d1x
	
firefs:
	make preparefs
	mkdir -p mkdir -p $(RAMFS)/home/user/fire
	cp src/fire/* $(RAMFS)/home/user/fire/
	cd $(RAMFS); chown -R 1000:1000 home/user
	make finishfs FILENAME=fire
	
fltkfs:
	make preparefs
	cd src/fltk; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=fltk

dillofs:
	make preparefs
	cd src/dillo; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=dillo

frontierfs:
	make preparefs
	mkdir -p $(RAMFS)/usr/share/games/frontier
	#cd src/frontvm2; cp frontier $(RAMFS)/usr/share/games/frontier/
	cd src/glfrontier; cp frontier $(RAMFS)/usr/share/games/frontier/
	cd src/glfrontier; cp cursor.png $(RAMFS)/usr/share/games/frontier/
	#cd src/frontvm2; cp font8.bmp $(RAMFS)/usr/share/games/frontier/
	cd src/glfrontier; cp fe2.s.bin $(RAMFS)/usr/share/games/frontier/
	cd src/frontvm2; cp -r sfx $(RAMFS)/usr/share/games/frontier/
	chmod u+s $(RAMFS)/usr/share/games/frontier/frontier
	make finishfs FILENAME=frontier

glibfs:
	make preparefs
	cd src/glib; find . -name "*.la" -exec sed -i~ -e "/relink/d" {} \;
	cd src/glib; make install DESTDIR=$(RAMFS)
	rm -rf $(RAMFS)/usr/share/aclocal
	rm -rf $(RAMFS)/usr/lib/glib-2.0/include
	rm -rf $(RAMFS)/usr/share/bash-completion
	rm -rf $(RAMFS)/usr/share/glib-2.0/gettext
	rm -rf $(RAMFS)/usr/share/glib-2.0/gdb
	rm -rf $(RAMFS)/usr/share/glib-2.0/codegen
	rm -rf $(RAMFS)/usr/share/gdb
	rm -f $(RAMFS)/usr/bin/gdbus-codegen
	rm -f $(RAMFS)/usr/lib/charset.alias
	make finishfs FILENAME=glib

pangofs:
	make preparefs
	cd src/pango; find . -name "*.la" -exec sed -i~ -e "/relink/d" {} \;
	cd src/pango; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=pango

atkfs:
	make preparefs
	#cd src/atk; find . -name "*.la" -exec sed -i~ -e "/relink/d" {} \;
	cd src/atk; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=atk

gdk-pixbuffs:
	make preparefs
	cd src/gdk-pixbuf; find . -name "*.la" -exec sed -i~ -e "/relink/d" {} \;
	cd src/gdk-pixbuf; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=gdk-pixbuf

gtkfs:
	make preparefs
	#cd src/gtk+; patch < ../../patches/libool_norelink.patch
	cd src/gtk+; find . -name "*.la" -exec sed -i~ -e "/relink/d" {} \;
	cd src/gtk+; make install DESTDIR=$(RAMFS)
	rm -rf $(RAMFS)/usr/lib/gtk-2.0/include
	rm -rf $(RAMFS)/usr/share/themes/Raleigh
	rm -rf $(RAMFS)/usr/share/themes/Emacs
	cd src/gtk+/demos/gtk-demo; make install DESTDIR=$(RAMFS)
	cd src/xzgv/src; cp xzgv $(RAMFS)/usr/bin/
	rm -rf  $(RAMFS)/usr/share/gtk-2.0/demo
	make finishfs FILENAME=gtk

cairofs:
	make preparefs
	cd src/cairo; patch < ../../patches/libool_norelink.patch
	#sys_lib_dlsearch_path_spec="/lib /usr/lib /usr/lib/libfakeroot "
	#sed -i~ -e "s;lt_sysroot=;lt_sysroot=$(SYSROOT);" src/cairo/libtool
	#sed -i~ -e "s;sys_lib_dlsearch_path_spec=\"/lib /usr/lib /usr/lib/libfakeroot \";sys_lib_dlsearch_path_spec=\"${SYSROOT}/lib ${SYSROOT}/usr/lib \";" src/cairo/libtool
	sed -i~ -e "/relink/d" src/cairo/util/cairo-script/libcairo-script-interpreter.la
	cd src/cairo; find . -type f -name "*.la" -print0 | xargs -r -0 sed -i -e "/relink/d"
	cd src/cairo; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=cairo

icufs:
	make preparefs
	cd src/icubuildB; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=icu

nsprfs:
	make preparefs
	cd src/nspr/nspr; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=nspr

libeventfs:
	make preparefs
	cd src/libevent; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=libevent

ltracefs:
	make preparefs
	cd src/ltrace; make install DESTDIR=$(RAMFS)
	or1k-linux-musl-gcc hello.c -o $(RAMFS)/usr/bin/hello
	make finishfs FILENAME=ltrace

mikmodfs:
	make preparefs
	cd src/libmikmod; make install DESTDIR=$(RAMFS)
	cd src/mikmod; make install DESTDIR=$(RAMFS)
	mkdir -p $(RAMFS)/home/user/
	cp patches/mikmodrc $(RAMFS)/home/user/.mikmodrc	
	cd $(RAMFS); chown -R 1000:1000 home/user
	mkdir -p $(RAMFS)/usr/share/mikmod/mod
	cp patches/playlist.mpl $(RAMFS)/usr/share/mikmod/
	cp downloads/mod/* $(RAMFS)/usr/share/mikmod/mod/
	make finishfs FILENAME=mikmod
	
libsidplayfs:
	make preparefs
	cd src/libsidplayfp; make install DESTDIR=$(RAMFS)
	cd src/sidplayfp; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=libsidplay

compilepackagesfs:
	make preparefs
	mkdir -p $(RAMFS)/var/compilepackages
	cp downloads/bc-1.06.95.tar.bz2 $(RAMFS)/var/compilepackages
	cp downloads/frotz-2.43d.tar.gz $(RAMFS)/var/compilepackages
	cp downloads/lua-5.2.3.tar.gz $(RAMFS)/var/compilepackages
	cp downloads/cmatrix-1.2a.tar.gz $(RAMFS)/var/compilepackages
	#cp downloads/linux-3.18.tar.xz $(RAMFS)/var/compilepackages
	make finishfs FILENAME=compilepackages


htopfs:
	make preparefs
	cd src/htop; make install DESTDIR=$(RAMFS)
	cp tools/mandelpar/mandelpar $(RAMFS)/usr/bin/
	make finishfs FILENAME=htop

firefoxfs:
	make preparefs
	cd src/firefox; make -f client.mk install INSTALL_SDK= DESTDIR=$(RAMFS)
	mkdir -pv $(RAMFS)/usr/lib/mozilla/plugins
	ln -sfv ../../mozilla/plugins $(RAMFS)/usr/lib/firefox-31.0/browser
	make finishfs FILENAME=firefox

firefoxprefs:
	make preparefs
	cd src/icubuildB; make install DESTDIR=$(RAMFS)
	#cd src/glib; make install DESTDIR=$(SYSROOT)
	#cd src/gtk+; make install DESTDIR=$(RAMFS)
	#cd src/atk; make install DESTDIR=$(RAMFS)
	#cd src/pango; make install DESTDIR=$(RAMFS)
	#cd src/gdk-pixbuf; make install DESTDIR=$(RAMFS)
	cd src/nspr/nspr; make install DESTDIR=$(RAMFS)
	cd src/libevent; make install DESTDIR=$(RAMFS)
	cd src/opus; make install DESTDIR=$(RAMFS)
	cd src/libvpx/build; make install DESTDIR=$(RAMFS)
	cd src/libogg; make install DESTDIR=$(RAMFS)
	cd src/libvorbis; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=firefoxpre

gitfs:
	make preparefs
	cd src/git; make install DESTDIR=$(RAMFS)
	mkdir -p $(RAMFS)/home/user
	echo -e "[user]\n\temail = user@jor1k.com" > $(RAMFS)/home/user/.gitconfig
	echo -e "[core]\n\tpager = more" >> $(RAMFS)/home/user/.gitconfig
	cd $(RAMFS); chown -R 1000:1000 home/user
	rm -rf $(RAMFS)/usr/lib/perl5
	rm -rf $(RAMFS)/usr/share/gitk
	rm -rf $(RAMFS)/usr/share/gitweb
	rm -rf $(RAMFS)/usr/share/perl5
	rm -rf $(RAMFS)/usr/share/git-gui
	rm -f  $(RAMFS)/usr/bin/gitk
	rm -f  $(RAMFS)/usr/bin/git-shell
	rm -f  $(RAMFS)/usr/bin/git-upload-pack
	rm -f  $(RAMFS)/usr/bin/git-cvsserver
	rm -f  $(RAMFS)/usr/bin/git-receive-pack
	rm -f  $(RAMFS)/usr/bin/git-upload-archive
	rm -f  $(RAMFS)/usr/libexec/git-core/git-credential*
	rm -f  $(RAMFS)/usr/libexec/git-core/git-cvs*
	rm -f  $(RAMFS)/usr/libexec/git-core/git-daemon
	rm -f  $(RAMFS)/usr/libexec/git-core/git-fast-import
	rm -f  $(RAMFS)/usr/libexec/git-core/git-gui*
	rm -f  $(RAMFS)/usr/libexec/git-core/git-instaweb
	rm -f  $(RAMFS)/usr/libexec/git-core/git-merge-octopus
	rm -f  $(RAMFS)/usr/libexec/git-core/git-merge-one-file
	#rm -f  $(RAMFS)/usr/libexec/git-core/git-remote-http
	rm -f  $(RAMFS)/usr/libexec/git-core/git-remote-testsvn
	rm -f  $(RAMFS)/usr/libexec/git-core/git-sh-*
	rm -f  $(RAMFS)/usr/libexec/git-core/git-show-index
	rm -f  $(RAMFS)/usr/libexec/git-core/git-p4
	rm -f  $(RAMFS)/usr/libexec/git-core/git-citool
	rm -f  $(RAMFS)/usr/libexec/git-core/git-http-*
	rm -f  $(RAMFS)/usr/libexec/git-core/git-imap-send
	make finishfs FILENAME=git

screenfs:
	make preparefs
	cd src/screen; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=screen

tmuxfs:
	make preparefs
	cd src/tmux; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=tmux


autoconffs:
	make preparefs
	cd src/autoconf; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=autoconf

m4fs:
	make preparefs
	cd src/m4; make install DESTDIR=$(RAMFS)
	mkdir -p $(RAMFS)/usr/sbin
	ln -s /usr/bin/m4 $(RAMFS)/usr/sbin/m4
	make finishfs FILENAME=m4

automakefs:
	make preparefs
	cd src/automake; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=automake

filefs:
	make preparefs
	cd src/file; make install DESTDIR=$(RAMFS)
	make finishfs FILENAME=file

aalibfs:
	make preparefs
	cd src/aalib; make install DESTDIR=$(RAMFS)
	rm $(RAMFS)/usr/bin/aalib-config
	make finishfs FILENAME=aalib

rubyfs:
	make preparefs
	cd src/ruby; make install DESTDIR=$(RAMFS)/temp
	cd $(RAMFS)/temp; cp --parents usr/bin/ruby ../
	cd $(RAMFS)/temp; cp --parents usr/bin/irb ../
	cd $(RAMFS)/temp; cp --parents usr/lib/ruby/2.1.0/irb.rb ../
	cd $(RAMFS)/temp; cp -r --preserve=links --parents usr/lib/ruby/2.1.0/irb/* ../
	cd $(RAMFS)/temp; cp --parents --preserve=links usr/lib/lib* ../
	cd $(RAMFS)/temp; cp -r --parents --preserve=links usr/lib/ruby/2.1.0/rubygems/* ../
	cd $(RAMFS)/temp; cp --parents usr/lib/ruby/2.1.0/or1k-linux-musl/enc/trans/transdb.so ../
	cd $(RAMFS)/temp; cp --parents usr/lib/ruby/2.1.0/or1k-linux-musl/thread.so ../
	cd $(RAMFS)/temp; cp --parents /usr/lib/ruby/2.1.0/monitor.rb ../
	cd $(RAMFS)/temp; cp --parents usr/lib/ruby/2.1.0/rubygems.rb ../
	cd $(RAMFS)/temp; cp --preserve=links --parents usr/lib/ruby/2.1.0/*.rb ../
	cd $(RAMFS)/temp; cp --parents usr/lib/ruby/2.1.0/or1k-linux-musl/enc/encdb.so ../
	cd $(RAMFS)/temp; cp --parents usr/lib/ruby/2.1.0/or1k-linux-musl/rbconfig.rb ../
	rm -rf $(RAMFS)/temp
	make finishfs FILENAME=ruby

libcacafs:
	make preparefs
	cd src/libcaca; patch < ../../patches/libool_norelink.patch
	cd src/libcaca; make install DESTDIR=$(RAMFS)
	rm -rf $(RAMFS)/usr/share/libcaca
	rm -rf $(RAMFS)/usr/lib/python3.4
	make finishfs FILENAME=libcaca

bbfs:
	make preparefs
	mkdir -p $(RAMFS)/usr/bin/
	cd src/bb; cp bb $(RAMFS)/usr/bin/
	make finishfs FILENAME=bb

phpfs:
	make preparefs
	cd src/php; make install INSTALL_ROOT=$(RAMFS)
	rm -rf $(RAMFS)/usr/lib/php
	rm $(RAMFS)/usr/bin/php-cgi
	rm $(RAMFS)/usr/bin/php-config
	rm $(RAMFS)/usr/bin/phpize
	make finishfs FILENAME=php


perlfs:
	make preparefs
	mkdir -p $(RAMFS)/temp
	cd src/perl; make install DESTDIR=$(RAMFS)/temp
	mkdir -p $(RAMFS)/usr/bin
	mkdir -p $(RAMFS)/usr/sbin
	mkdir -p $(RAMFS)/usr/lib/perl5/5.20.1
	mkdir -p $(RAMFS)/usr/lib/perl5/5.20.1/or1k-musl
	mkdir -p $(RAMFS)/usr/lib/perl5/5.20.1/warnings
	mkdir -p $(RAMFS)/usr/lib/perl5/5.20.1/Exporter
	mkdir -p $(RAMFS)/usr/lib/perl5/5.20.1/File
	mkdir -p $(RAMFS)/usr/lib/perl5/5.20.1/Tie
	mkdir -p $(RAMFS)/usr/lib/perl5/5.20.1/Spec
	mkdir -p $(RAMFS)/usr/lib/perl5/5.20.1/Class
	mkdir -p $(RAMFS)/usr/lib/perl5/5.20.1/o1k-musl/IO
	cp $(RAMFS)/temp/usr/bin/perl $(RAMFS)/usr/bin/
	cp $(RAMFS)/temp/usr/lib/perl5/5.20.1/strict.pm $(RAMFS)/usr/lib/perl5/5.20.1/
	cp $(RAMFS)/temp/usr/lib/perl5/5.20.1/warnings.pm $(RAMFS)/usr/lib/perl5/5.20.1/
	cp $(RAMFS)/temp/usr/lib/perl5/5.20.1/Exporter.pm $(RAMFS)/usr/lib/perl5/5.20.1/
	cp $(RAMFS)/temp/usr/lib/perl5/5.20.1/Exporter/Heavy.pm $(RAMFS)/usr/lib/perl5/5.20.1/Exporter/
	cp $(RAMFS)/temp/usr/lib/perl5/5.20.1/warnings/register.pm $(RAMFS)/usr/lib/perl5/5.20.1/warnings
	cp $(RAMFS)/temp/usr/lib/perl5/5.20.1/vars.pm $(RAMFS)/usr/lib/perl5/5.20.1/
	cp $(RAMFS)/temp/usr/lib/perl5/5.20.1/XSLoader.pm $(RAMFS)/usr/lib/perl5/5.20.1/
	cp $(RAMFS)/temp/usr/lib/perl5/5.20.1/or1k-musl/DynaLoader.pm $(RAMFS)/usr/lib/perl5/5.20.1/
	cp $(RAMFS)/temp/usr/lib/perl5/5.20.1/or1k-musl/Config.pm $(RAMFS)/usr/lib/perl5/5.20.1/or1k-musl/
	cp $(RAMFS)/temp/usr/lib/perl5/5.20.1/File/Basename.pm $(RAMFS)/usr/lib/perl5/5.20.1/File/
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/Errno.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/Carp.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/base.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/IO.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/auto/IO/IO.so ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/auto/Fcntl/Fcntl.so ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/auto/threads/shared/shared.so ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/auto/List/Util/Util.so ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/auto/threads/threads.so ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/auto/attributes/attributes.so ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/auto/POSIX/POSIX.so ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/auto/Data/Dumper/Dumper.so ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/auto/Cwd/Cwd.so ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/IO/File.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/IO/Seekable.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/IO/Handle.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/Symbol.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/SelectSaver.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/Fcntl.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/constant.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/File/stat.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/File/Find.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/File/Glob.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/auto/File/Glob/Glob.so ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/File/Spec/Unix.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/File/Spec.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/File/Compare.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/File/Copy.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/File/Path.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/Class/Struct.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/Getopt/Long.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/attributes.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/Carp.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/Tie/Hash.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/overload.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/overloading.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/POSIX.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/Data/Dumper.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/bytes.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/or1k-musl/Cwd.pm ../
	cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/Text/ParseWords.pm ../
	#for prove:
	#cp $(RAMFS)/temp/usr/bin/prove $(RAMFS)/usr/bin/
	#cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/App/Prove.pm ../
	#cd $(RAMFS)/temp; cp --parents usr/lib/perl5/5.20.1/TAP/Harness.pm ../
	#cd $(RAMFS)/temp; cp -r usr/lib/perl5/5.20.1/TAP/* $(RAMFS)/usr/lib/perl5/5.20.1/TAP/
	#cd $(RAMFS)/temp; cp -r usr/lib/perl5/5.20.1/App/* $(RAMFS)/usr/lib/perl5/5.20.1/App/
	#cd $(RAMFS)/temp; cp -r usr/lib/perl5/5.20.1/* $(RAMFS)/usr/lib/perl5/5.20.1/
	ln -s /usr/bin/perl $(RAMFS)/usr/sbin/perl
	rm -rf $(RAMFS)/temp
	make finishfs FILENAME=perl


vimfs:
	make preparefs
	cd src/vim; make install DESTDIR=$(RAMFS)
	rm -rf $(RAMFS)/usr/share/vim/vim74/lang
	rm -rf $(RAMFS)/usr/share/vim/vim74/doc
	rm -rf $(RAMFS)/usr/share/vim/vim74/tutor
	rm -rf $(RAMFS)/usr/share/vim/vim74/spell
	rm -rf $(RAMFS)/usr/share/vim/vim74/syntax
	rm -rf $(RAMFS)/usr/share/vim/vim74/ftplugin
	rm -rf $(RAMFS)/usr/share/vim/vim74/compiler
	rm -rf $(RAMFS)/usr/share/vim/vim74/tools
	rm -rf $(RAMFS)/usr/share/vim/vim74/autoload
	rm -rf $(RAMFS)/usr/share/vim/vim74/indent
	rm -rf $(RAMFS)/usr/share/vim/vim74/macros
	rm -rf $(RAMFS)/usr/share/vim/vim74/keymap
	rm -rf $(RAMFS)/usr/share/vim/vim74/plugin
	make finishfs FILENAME=vim

flispfs:
	make preparefs
	mkdir -p $(RAMFS)/usr/bin
	cp src/femtolisp/flisp $(RAMFS)/usr/bin/
	cp src/femtolisp/flisp.boot $(RAMFS)/usr/bin/
	make finishfs FILENAME=flisp
	


tclfs:
	make preparefs
	cd src/tcl/unix; make install INSTALL_ROOT=$(RAMFS)
	ln -v -sf tclsh8.6 $(RAMFS)/usr/bin/tclsh
	rm $(RAMFS)/usr/lib/tclConfig.sh
	rm $(RAMFS)/usr/lib/tclooConfig.sh
	rm -rf $(RAMFS)/usr/lib/tdbc1.0.2
	rm -rf $(RAMFS)/usr/lib/tdbcmysql1.0.2
	rm -rf $(RAMFS)/usr/lib/sqlite3.8.7.1
	rm -rf $(RAMFS)/usr/lib/tdbcodbc1.0.2
	rm -rf $(RAMFS)/usr/lib/itcl4.0.2
	rm -rf $(RAMFS)/usr/lib/tcl8.6/opt0.4
	rm -rf $(RAMFS)/usr/lib/tcl8.6/msgs
	rm -rf $(RAMFS)/usr/lib/tcl8.6/encoding
	rm -rf $(RAMFS)/usr/lib/tdbcpostgres1.0.2
	rm -rf $(RAMFS)/usr/lib/thread2.7.1
	rm -rf $(RAMFS)/usr/lib/tcl8.6/http1.0
	#rm -rf $(RAMFS)/usr/lib/tcl8.6
	rm -rf $(RAMFS)/usr/lib/tcl8
	make finishfs FILENAME=tcl

pythonfs:
	make preparefs
	cd src/Python; make install DESTDIR=$(RAMFS)
	find $(RAMFS)/usr/lib/python2.7/ -name '*.pyo' -or -name '*.pyc' -exec rm {} \;
	rm -rf $(RAMFS)/usr/lib/python2.7/lib-tk/*
	rm -rf $(RAMFS)/usr/lib/python2.7/plat-linux2/*
	#rm -rf $(RAMFS)/usr/lib/python2.7/lib-dynload/*
	#rm -f $(RAMFS)/usr/lib/python2.7/*.py
	rm -rf $(RAMFS)/usr/lib/python2.7/lib-tk/test
	rm -rf $(RAMFS)/usr/lib/python2.7/ctypes/test
	rm -rf $(RAMFS)/usr/lib/python2.7/bsddb/test
	rm -rf $(RAMFS)/usr/lib/python2.7/unittest/test
	rm -rf $(RAMFS)/usr/lib/python2.7/test
	rm -rf $(RAMFS)/usr/lib/python2.7/email/test
	rm -rf $(RAMFS)/usr/lib/python2.7/config
	rm -rf $(RAMFS)/usr/lib/python2.7/lib2to3
	rm -rf $(RAMFS)/usr/lib/python2.7/curses
	rm -rf $(RAMFS)/usr/lib/python2.7/ctypes
	rm -rf $(RAMFS)/usr/lib/python2.7/idlelib
	rm -rf $(RAMFS)/usr/lib/python2.7/encodings
	rm -rf $(RAMFS)/usr/lib/python2.7/json
	rm -rf $(RAMFS)/usr/lib/python2.7/distutils
	rm -rf $(RAMFS)/usr/lib/python2.7/multiprocessing
	rm -rf $(RAMFS)/usr/lib/python2.7/bsddb
	rm -rf $(RAMFS)/usr/lib/python2.7/unittest
	rm -rf $(RAMFS)/usr/lib/python2.7/xml
	rm -rf $(RAMFS)/usr/lib/python2.7/wsgiref
	rm -rf $(RAMFS)/usr/lib/python2.7/test
	rm -rf $(RAMFS)/usr/lib/python2.7/pydoc_data
	rm -rf $(RAMFS)/usr/lib/python2.7/email
	rm -rf $(RAMFS)/usr/lib/python2.7/compiler
	rm -rf $(RAMFS)/usr/lib/python2.7/site-packages
	rm -rf $(RAMFS)/usr/lib/python2.7/importlib
	rm -rf $(RAMFS)/usr/lib/python2.7/hotshot
	rm -rf $(RAMFS)/usr/lib/python2.7/logging
	rm -rf $(RAMFS)/usr/lib/python2.7/sqlite3
	cd $(RAMFS)/usr/lib/python2.7; rm -f A* b* B* C* d* D* e* E* f* F* G* h* H* i* I* j* J* k* K* 
	cd $(RAMFS)/usr/lib/python2.7; rm -f z* Z* y* Y* x* X* W* u* T* S* m* M* n* N* O* P* q* Q* R*
	rm $(RAMFS)/usr/bin/python2-config
	rm $(RAMFS)/usr/bin/python2.7-config
	rm $(RAMFS)/usr/bin/idle
	rm $(RAMFS)/usr/bin/2to3
	rm $(RAMFS)/usr/bin/smtpd.py
	rm $(RAMFS)/usr/bin/python-config
	rm $(RAMFS)/usr/bin/pydoc
	make finishfs FILENAME=python noremove=1

expectfs:
	make preparefs
	cd src/expect; make DESTDIR=$(RAMFS) install-binaries
	make finishfs FILENAME=expect

timidityfs:
	make preparefs
	cd src/TiMidity++; make DESTDIR=$(RAMFS) install
	mkdir -p $(RAMFS)/usr/share/timidity
	cp patches/timidity/*.sf2 $(RAMFS)/usr/share/timidity/
	echo "soundfont /usr/share/timidity/1mgm.sf2" > $(RAMFS)/usr/share/timidity/timidity.cfg
	echo "opt EFresamp=d          #use linear resampling" >> $(RAMFS)/usr/share/timidity/timidity.cfg
	echo "opt EFvlpf=d            #disable VLPF" >> $(RAMFS)/usr/share/timidity/timidity.cfg
	echo "opt EFreverb=d          #disable reverb" >> $(RAMFS)/usr/share/timidity/timidity.cfg
	echo "opt EFchorus=d          #disable chorus" >> $(RAMFS)/usr/share/timidity/timidity.cfg
	echo "opt EFdelay=d           #disable delay" >> $(RAMFS)/usr/share/timidity/timidity.cfg
	echo "opt --no-anti-alias     #disable sample anti-alias" >> $(RAMFS)/usr/share/timidity/timidity.cfg
	echo "opt s22kHz              #default sample frequency to 22kHz" >> $(RAMFS)/usr/share/timidity/timidity.cfg
	echo "opt fast-decay          #fast decay notes" >> $(RAMFS)/usr/share/timidity/timidity.cfg
	echo "opt p32a                #default to 32 voices" >> $(RAMFS)/usr/share/timidity/timidity.cfg
	make finishfs FILENAME=timidity

