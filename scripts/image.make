#note the memory limit in the dts file!
#export SDL_MOUSEDRV=TSLIB
#export SDL_MOUSEDEV=/dev/input/event0
#export SDL_VIDEODRIVER=directfb

RAMFS = $(PWD)/src/linux/arch/openrisc/support/initramfs

basesystem:
	mkdir -p $(RAMFS)/proc
	mkdir -p $(RAMFS)/dev
	mkdir -p $(RAMFS)/sys
	mkdir -p $(RAMFS)/etc
	mkdir -p $(RAMFS)/sbin
	mkdir -p $(RAMFS)/tmp
	mkdir -p $(RAMFS)/root
	mkdir -p $(RAMFS)/lib
	mkdir -p $(RAMFS)/usr
	mkdir -p $(RAMFS)/var
	mkdir -p $(RAMFS)/var/empty
	mkdir -p $(RAMFS)/usr/bin
	mkdir -p $(RAMFS)/usr/lib
	mkdir -p $(RAMFS)/usr/share
	mkdir -p $(RAMFS)/usr/sbin
	mkdir -p $(RAMFS)/usr/libexec
	rm -rf $(RAMFS)/etc/*
	rm -rf $(RAMFS)/usr/lib/*
	rm -rf $(RAMFS)/usr/share/*
	rm -rf $(RAMFS)/root/*
	rm -rf $(RAMFS)/root/.??*
	rm -rf $(RAMFS)/bin/*
	rm -rf $(RAMFS)/sbin/*
	rm -rf $(RAMFS)/usr/bin/*
	rm -rf $(RAMFS)/usr/sbin/*
	rm -rf $(RAMFS)/usr/libexec/*	
	rm -rf $(RAMFS)/usr/include/*
	cp -Pr patches/init/* $(RAMFS)/
	#cp $(SYSROOT)/bin/busybox $(RAMFS)/bin/
	cd src/busybox; make CONFIG_PREFIX=$(RAMFS) install

basesystemfinish:
	rm -f  $(RAMFS)/usr/lib/*.la
	rm -f  $(RAMFS)/usr/lib/*.la~
	rm -f  $(RAMFS)/usr/lib/*.py
	rm -f  $(RAMFS)/usr/lib/*.a
	#This file is needed for gcc
	cp $(SYSROOT)/usr/lib/uclibc_nonshared.a $(RAMFS)/usr/lib/
	find $(RAMFS) -type f -executable -exec $(TOOLCHAIN_TARGET)-strip --strip-unneeded {} \;

basesystemuclibc:
	cp -P $(SYSROOT)/usr/lib/libgcc_s* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libstdc++* $(RAMFS)/usr/lib/
	cp -Pv $(SYSROOT)/lib/* $(RAMFS)/lib/
	cp $(SYSROOT)/usr/bin/ldd $(RAMFS)/usr/bin/

basesystemeglibc:
	cp $(SYSROOT)/usr/bin/ldd $(RAMFS)/usr/bin/
	cp -Pv $(SYSROOT)/lib/ld* $(RAMFS)/lib/
	cp -Pv $(SYSROOT)/lib/libc-* $(RAMFS)/lib/
	cp -Pv $(SYSROOT)/lib/libc.* $(RAMFS)/lib/

demo:
	make basesystem
	make basesystemuclibc
	cp -P $(SYSROOT)/usr/lib/libz* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libncurses* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libcurses* $(RAMFS)/usr/lib/
	cp $(SYSROOT)/usr/bin/strace $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/nano $(RAMFS)/usr/bin/
	cp -Prf $(SYSROOT)/usr/share/nano $(RAMFS)/usr/share
	ln -s nano $(RAMFS)/usr/bin/pico
	#---first image---
	#make graphicdemos
	#make terminaldemo
	#make tsdemo
	#make monkeyislanddemo
	#make directfbdemo
	#cp -P $(SYSROOT)/usr/bin/dosbox* $(RAMFS)/usr/bin/
	#---second image---
	#make gccdemo
	#cp -rPf src/libffi $(RAMFS)/root/
	#rm -rf $(RAMFS)/root/libffi/.git/
	#cd $(RAMFS)/root/libffi; make distclean
	#cp $(SYSROOT)/usr/bin/runtest $(RAMFS)/usr/bin/
	#cp $(SYSROOT)/usr/include/dejagnu.h $(RAMFS)/usr/include/
	#cp -rfP $(SYSROOT)/usr/share/dejagnu $(RAMFS)/usr/share/
	#---third image---
	#make graphicdemos
	#make tsdemo
	#make terminaldemo
	#make Xdemo
	#make fluxboxdemo
	#make quakedemo
	#---fourth image---
	#make waylanddemo
	#---fifth image----
	make tsdemo
	make networkdemo
	#-----------------
	make basesystemfinish

linuximagedemo:
	make demo RAMFS=$(PWD)/src/linux/arch/openrisc/support/initramfs
	cd src/linux; make
	cd src/linux; $(TOOLCHAIN_TARGET)-objcopy -O binary vmlinux vmlinux.bin
	cd src/linux; bzip2 -f --best vmlinux.bin

gccdemo:
	echo "date -s \"2014-01-01 00:00\"" >> $(RAMFS)/root/.profile
	cp -rfp patches/code/* $(RAMFS)/root/
	cp $(SYSROOT)/usr/bin/joe $(RAMFS)/usr/bin/
	cp -rfp $(SYSROOT)/usr/share/joe $(RAMFS)/usr/share
	cp -rfp $(SYSROOT)/usr/etc/joe $(RAMFS)/etc
	mkdir -p $(RAMFS)/usr/libexec/gcc/or1k-linux/4.8.1
	cp $(SYSROOT)/usr/bin/gcc $(RAMFS)/usr/bin/
	ln -s gcc $(RAMFS)/usr/bin/cc
	cp $(SYSROOT)/usr/bin/make $(RAMFS)/usr/bin/	
	cp $(SYSROOT)/usr/bin/objdump $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/strip $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/as $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/ld $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/ar $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/nm $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/ranlib $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/lib/crt*.o $(RAMFS)/usr/lib/
	cp $(SYSROOT)/usr/libexec/gcc/or1k-linux/4.8.1/cc1 $(RAMFS)/usr/libexec/gcc/or1k-linux/4.8.1/
	cp $(SYSROOT)/usr/libexec/gcc/or1k-linux/4.8.1/collect2 $(RAMFS)/usr/libexec/gcc/or1k-linux/4.8.1/
	cp $(SYSROOT)/usr/libexec/gcc/or1k-linux/4.8.1/lto-wrapper $(RAMFS)/usr/libexec/gcc/or1k-linux/4.8.1/
	mkdir -p $(RAMFS)/usr/include
	mkdir -p $(RAMFS)/usr/include/bits
	mkdir -p $(RAMFS)/usr/include/sys
	mkdir -p $(RAMFS)/usr/include/linux
	mkdir -p $(RAMFS)/usr/include/asm
	mkdir -p $(RAMFS)/usr/include/asm-generic
	cp -rf $(SYSROOT)/usr/include/bits/* $(RAMFS)/usr/include/bits/
	cp -rf $(SYSROOT)/usr/include/asm/* $(RAMFS)/usr/include/asm/
	cp -rf $(SYSROOT)/usr/include/asm-generic/* $(RAMFS)/usr/include/asm-generic/
	cp -rf $(SYSROOT)/usr/include/sys/* $(RAMFS)/usr/include/sys/
	cp $(SYSROOT)/usr/include/stdio.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/stdlib.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/string.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/errno.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/unistd.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/fcntl.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/pthread.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/wchar.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/sched.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/time.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/signal.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/endian.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/byteswap.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/features.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/alloca.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/assert.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/math.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/complex.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/ctype.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/unctrl.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/termios.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/termio.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/limits.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/memory.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/strings.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/inttypes.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/stdint.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/dlfcn.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/mntent.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/paths.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/cur*.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/ncur*.h $(RAMFS)/usr/include/
	cp $(SYSROOT)/usr/include/linux/fb.h $(RAMFS)/usr/include/linux/
	cp $(SYSROOT)/usr/include/linux/param.h $(RAMFS)/usr/include/linux/
	cp $(SYSROOT)/usr/include/linux/errno.h $(RAMFS)/usr/include/linux/
	cp $(SYSROOT)/usr/include/linux/types.h $(RAMFS)/usr/include/linux/
	cp $(SYSROOT)/usr/include/linux/posix_types.h $(RAMFS)/usr/include/linux/
	cp $(SYSROOT)/usr/include/linux/i2c.h $(RAMFS)/usr/include/linux/
	cp $(SYSROOT)/usr/include/linux/ioctl.h $(RAMFS)/usr/include/linux/
	cp $(SYSROOT)/usr/include/linux/stddef.h $(RAMFS)/usr/include/linux/
	cp $(SYSROOT)/usr/include/linux/termios.h $(RAMFS)/usr/include/linux/
	cp $(SYSROOT)/usr/include/linux/limits.h $(RAMFS)/usr/include/linux/
	mkdir -p $(RAMFS)/usr/lib/gcc/or1k-linux/4.8.1/include
	cp -Pr $(SYSROOT)/usr/lib/gcc/or1k-linux/4.8.1/* $(RAMFS)/usr/lib/gcc/or1k-linux/4.8.1/
	cp -P $(SYSROOT)/usr/libexec/gcc/or1k-linux/4.8.1/liblto_plugin* $(RAMFS)/usr/libexec/gcc/or1k-linux/4.8.1/
	cp $(SYSROOT)/usr/lib/libpthread.so $(RAMFS)/usr/lib/
	cp $(SYSROOT)/usr/lib/libc.so $(RAMFS)/usr/lib/
	cp $(SYSROOT)/usr/lib/libm.so $(RAMFS)/usr/lib/
	cp $(SYSROOT)/usr/lib/uclibc_nonshared.a $(RAMFS)/usr/lib/

graphicdemos:
	or1k-linux-gcc patches/code/fbdemo.c -O2 -o $(SYSROOT)/usr/bin/fbdemo
	cp $(SYSROOT)/usr/bin/fbdemo $(RAMFS)/usr/bin/
	cp -P $(SYSROOT)/usr/lib/libpng16* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libjpeg* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libfreetype* $(RAMFS)/usr/lib/

networkdemo:
	cp -P $(SYSROOT)/usr/lib/libdirect* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libfusion* $(RAMFS)/usr/lib/
	cp -r $(SYSROOT)/usr/lib/directfb-1.6-0 $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libpng16* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libjpeg* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libssl* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libcrypto* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libcurl* $(RAMFS)/usr/lib/
	cp $(SYSROOT)/usr/bin/dfbinfo* $(RAMFS)/usr/bin/
	mkdir -p $(RAMFS)/usr/share/boot
	cp patches/network-info.jpg $(RAMFS)/usr/share/boot
	sed -i '20ifbview /usr/share/boot/network-info.jpg' $(RAMFS)/etc/init.d/rcS
	cp -Pr $(SYSROOT)/etc/lynx $(RAMFS)/etc/
	cp -Pr $(SYSROOT)/etc/ssh $(RAMFS)/etc/
	#cp -Pr src/nbench-byte $(RAMFS)/root/
	cp $(SYSROOT)/etc/ytalkrc $(RAMFS)/etc/
	cp -Pr $(SYSROOT)/usr/share/nmap $(RAMFS)/usr/share/
	cp $(SYSROOT)/usr/bin/lynx $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/links $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/nmap $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/ssh $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/sbin/sshd $(RAMFS)/sbin/
	cp $(SYSROOT)/usr/bin/ssh-keygen $(RAMFS)/usr/bin
	ssh-keygen -t rsa -f $(RAMFS)/etc/ssh/ssh_host_rsa_key
	cp src/busybox/applets_sh/nologin $(RAMFS)/sbin/
	cp $(SYSROOT)/usr/bin/scp $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/curl $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/iperf $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/ytalk $(RAMFS)/usr/bin/
	cd patches/write/; or1k-linux-gcc -I. write.c -o write
	cp patches/write/write $(RAMFS)/usr/bin/
	#cp src/netkit-ntalk/talk/talk $(RAMFS)/usr/bin/
	#cd patches/fbview/;  or1k-linux-gcc fbview.c -I$(SYSROOT)/usr/include/directfb -ldirectfb -o fbview
	cd patches/fbview/; make clean
	cd patches/fbview/; make CC=or1k-linux-gcc
	cp patches/fbview/fbview  $(RAMFS)/usr/bin/
	#cp src/dpf-project-read-only/utils/fbview/fbview $(RAMFS)/usr/bin/
	#cp -P $(SYSROOT)/usr/lib/libgpg-error* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libgcrypt* $(RAMFS)/usr/lib/
	#cp $(SYSROOT)/usr/bin/weechat $(RAMFS)/usr/bin/
	#cp -Pr $(SYSROOT)/usr/lib/weechat $(RAMFS)/usr/lib


terminaldemo:
	cp src/ncurses/test/worm $(RAMFS)/usr/bin/
	cp src/ncurses/test/knight $(RAMFS)/usr/bin/
	cp src/ncurses/test/hanoi $(RAMFS)/usr/bin/
	cp src/ncurses/test/firework $(RAMFS)/usr/bin/
	cp src/ncurses/test/railroad $(RAMFS)/usr/bin/
	cp src/ncurses/test/rain $(RAMFS)/usr/bin/
	cp src/ncurses/test/xmas $(RAMFS)/usr/bin/
	cp src/ncurses/test/blue $(RAMFS)/usr/bin/
	cp src/ncurses/test/bs $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/bc $(RAMFS)/usr/bin/	

tsdemo:
	cp $(SYSROOT)/usr/bin/ts_test $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/ts_calibrate $(RAMFS)/usr/bin/
	mkdir -p $(RAMFS)/usr/lib/ts
	cp -P $(SYSROOT)/usr/lib/libts* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/ts/input.so $(RAMFS)/usr/lib/ts/

directfbdemo:
	cp -P $(SYSROOT)/usr/lib/libdirect* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libfusion* $(RAMFS)/usr/lib/
	cp -r $(SYSROOT)/usr/lib/directfb-1.6-0 $(RAMFS)/usr/lib/
	cp -r $(SYSROOT)/usr/share/directfb-1.6.3 $(RAMFS)/usr/share/
	cp -r $(SYSROOT)/usr/share/directfb-examples $(RAMFS)/usr/share/
	cp $(SYSROOT)/usr/bin/df_* $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/dfb* $(RAMFS)/usr/bin/

quakedemo:
	cp -P $(SYSROOT)/usr/lib/libXxf86dga* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXxf86vm* $(RAMFS)/usr/lib/
	cp src/tyrquake-0.61/tyr-glquake $(RAMFS)/usr/bin/
	cp src/tyrquake-0.61/tyr-glqwcl $(RAMFS)/usr/bin/
	cp src/tyrquake-0.61/tyr-quake $(RAMFS)/usr/bin/
	cp src/tyrquake-0.61/tyr-qwcl $(RAMFS)/usr/bin/
	cp src/tyrquake-0.61/tyr-qwsv $(RAMFS)/usr/bin/
	mkdir -p $(RAMFS)/root/.tyrquake/id1
	cp -rf downloads/quake/id1/* $(RAMFS)/root/.tyrquake/id1/

Xdemo:
	echo "startx" >> $(RAMFS)/root/.profile
	echo "sleep 3" >> $(RAMFS)/root/.profile
	echo "exec twm &" >> $(RAMFS)/root/.profile
	echo "sleep 3" >> $(RAMFS)/root/.profile
	echo "exec glxgears &" >> $(RAMFS)/root/.profile
	#cp -P $(SYSROOT)/usr/lib/libOSMesa* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libGLU* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libGL.* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXext* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libX11* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libxcb* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXau* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXdmcp* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXext* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libpixman* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXfont* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libfontenc* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libxkbfile* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXmu* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXt* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXrender* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libSM* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libICE* $(RAMFS)/usr/lib/
	# --- BINARIES ---
	cp $(SYSROOT)/usr/bin/Xfbdev $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/xeyes $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/glxinfo $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/glxgears $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/xkbcomp $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/xterm $(RAMFS)/usr/bin/
	cp src/xtic/src/xtic $(RAMFS)/usr/bin/
	cp patches/startx $(RAMFS)/usr/bin/
	cp -P $(SYSROOT)/usr/lib/libXft* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXaw* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXpm* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libfontconfig* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libexpat* $(RAMFS)/usr/lib/
	# ---------------
	#cp src/demos-mesa-demos/src/demos/terrain $(RAMFS)/usr/bin/
	#cp -P $(SYSROOT)/usr/lib/libglut* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libGLEW* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libXi* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libXrandr* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libXxf86vm** $(RAMFS)/usr/lib/
	# --- Protocols ---
	cp -Prf $(SYSROOT)/usr/lib/xorg $(RAMFS)/usr/lib/
	mkdir -p $(RAMFS)/usr/share/X11
	cp -rP $(SYSROOT)/usr/share/X11 $(RAMFS)/usr/share/
	# --- TWM ---
	cp $(SYSROOT)/usr/bin/twm $(RAMFS)/usr/bin/
	cp patches/system.twmrc $(RAMFS)/usr/share/X11/twm/
	# -----------
	# --- XKB ---
	rm -rf $(RAMFS)/usr/share/X11/xkb/symbols/*
	cp $(SYSROOT)/usr/share/X11/xkb/symbols/pc $(RAMFS)/usr/share/X11/xkb/symbols/
	cp $(SYSROOT)/usr/share/X11/xkb/symbols/srvr_ctrl $(RAMFS)/usr/share/X11/xkb/symbols/
	cp $(SYSROOT)/usr/share/X11/xkb/symbols/keypad $(RAMFS)/usr/share/X11/xkb/symbols/
	cp $(SYSROOT)/usr/share/X11/xkb/symbols/altwin $(RAMFS)/usr/share/X11/xkb/symbols/
	cp $(SYSROOT)/usr/share/X11/xkb/symbols/us $(RAMFS)/usr/share/X11/xkb/symbols/
	cp $(SYSROOT)/usr/share/X11/xkb/symbols/inet $(RAMFS)/usr/share/X11/xkb/symbols/
	# -----------
	mkdir -p $(RAMFS)/var/cache/fontconfig
	mkdir -p $(RAMFS)/etc/fonts
	#cp -rP $(SYSROOT)/etc/fonts $(RAMFS)/etc/
	# --- FONTS ---
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
	#cp -rP $(SYSROOT)/usr/share/fonts $(RAMFS)/usr/share/	
	# -----------------
	#cp patches/*.ttf $(RAMFS)/usr/share/fonts/X11/TTF/
	#cp -rP $(SYSROOT)/usr/share/fonts $(RAMFS)/usr/share/	
	rm -rf $(RAMFS)/usr/share/X11/locale/*
	#cp $(SYSROOT)/usr/share/X11/locale/locale.alias $(RAMFS)/usr/share/X11/locale/

waylanddemo:
	cp -P $(SYSROOT)/usr/lib/libway* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libffi.* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libpixman* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libxkbcommon* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libudev* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libmtdev* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libdrm* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libGL* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libEGL* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libXext* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libX11* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libxcb* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libXau* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libXdmcp* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libXext* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libXxf86vm* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libXdamage* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libXfixes* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libgbm* $(RAMFS)/usr/lib/
	#cp -P $(SYSROOT)/usr/lib/libglapi* $(RAMFS)/usr/lib/
	#cp -rfP $(SYSROOT)/usr/lib/dri $(RAMFS)/usr/lib/
	cp -Prf $(SYSROOT)/usr/lib/weston* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/bin/weston* $(RAMFS)/usr/bin/
	cp -P $(SYSROOT)/usr/libexec/weston* $(RAMFS)/usr/libexec/
	cp -Prf $(SYSROOT)/usr/share/weston $(RAMFS)/usr/share/
	#echo "export XDG_RUNTIME_DIR=/tmp" >> $(RAMFS)/root/.profile
	#---Terminal---
	cp -P $(SYSROOT)/usr/lib/libcairo* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libfontconfig* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libexpat* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libfreetype* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libpng* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libjpeg* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libfreetype* $(RAMFS)/usr/lib/
	#---XKB---
	mkdir -p $(RAMFS)/usr/share/X11/xkb
	cp -rfP $(SYSROOT)/usr/share/X11/xkb $(RAMFS)/usr/share/X11/
	#---weston.ini---
	mkdir -p $(RAMFS)/root/.config
	cp patches/weston.ini $(RAMFS)/root/.config/
	#--------
	echo "weston --backend=fbdev-backend.so" >> $(RAMFS)/usr/bin/startweston
	chmod u+x $(RAMFS)/usr/bin/startweston
	cp -prf patches/weston/* $(RAMFS)/usr/share/
	#-------
	cp $(SYSROOT)/usr/bin/fc-* $(RAMFS)/usr/bin/
	mkdir -p $(RAMFS)/var/cache/fontconfig
	mkdir -p $(RAMFS)/etc/fonts
	cp -rP $(SYSROOT)/etc/fonts $(RAMFS)/etc/
	# --- FONTS ---
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
	#cp -rP $(SYSROOT)/usr/share/fonts $(RAMFS)/usr/share/	
	echo "startweston &" >> $(RAMFS)/root/.profile

fluxboxdemo:
	cp $(SYSROOT)/usr/bin/fluxbox $(RAMFS)/usr/bin/
	cp $(SYSROOT)/usr/bin/startfluxbox $(RAMFS)/usr/bin/
	cp -P $(SYSROOT)/usr/lib/libXrandr* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXinerama* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXpm* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libXft* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libfontconfig* $(RAMFS)/usr/lib/
	cp -P $(SYSROOT)/usr/lib/libexpat* $(RAMFS)/usr/lib/
	mkdir -p $(RAMFS)/usr/share/fluxbox
	cp -rP $(SYSROOT)/usr/share/fluxbox $(RAMFS)/usr/share/
	mkdir -p $(RAMFS)/root/.fluxbox
	cp $(SYSROOT)/usr/share/fluxbox/init $(RAMFS)/root/.fluxbox/
	cp $(SYSROOT)/usr/share/fluxbox/keys $(RAMFS)/root/.fluxbox/
	cp $(SYSROOT)/usr/share/fluxbox/menu $(RAMFS)/root/.fluxbox/

monkeyislanddemo:
	cp -P $(SYSROOT)/usr/lib/libSDL* $(RAMFS)/usr/lib/
	cp src/scummvm/scummvm $(RAMFS)/usr/bin/
	cp -P patches/scummvmrc $(RAMFS)/root/.scummvmrc
	mkdir -p $(RAMFS)/root/monkey
	rm -rf $(RAMFS)/root/monkey/*
	cp -r downloads/monkey/* $(RAMFS)/root/monkey/




baselinuxshareddemo:
	make basesystem
	#make basesystemeglibc
	#$(CC) patches/code/hello.c -o $(RAMFS)/hello
	make demo
	make basesystemfinish
	cd src/linux; make
	cd src/linux; $(TOOLCHAIN_TARGET)-objcopy -O binary vmlinux vmlinux.bin
	cd src/linux; bzip2 -f --best vmlinux.bin

mke2img:
	gcc patches/mke2img.c -o mke2img -lext2fs -lcom_err

buildimage:
	mkdir -p hd
	make demo RAMFS=$(PWD)/hd
	dd if=/dev/zero of=ext2fsimage bs=1M count=30
	#mkfs.ext2 -F ext2fsimage -b 4096
	mkfs.ext2 -F ext2fsimage
	#cp patches/startchroot $(SYSROOT)
	#chmod u+x $(SYSROOT)/startchroot
	#./mke2img ext2fsimage $(SYSROOT)
	./mke2img ext2fsimage hd/
	bzip2 -f --best ext2fsimage

splitimage:
	mkdir -p hd
	split -d -a4 --bytes=512K ext2fsimage hd/hd

