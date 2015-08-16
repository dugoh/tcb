fetchtoolchain:
	$(MAKE) fetch$(TOOLCHAIN)toolchain

toolchain:
	$(MAKE) $(TOOLCHAIN)_toolchain

fetchmusltoolchain: 
	cd downloads; wget ftp://sourceware.org/pub/binutils/snapshots/binutils-@VERSION@.tar.bz2 
	cd src; git clone git://github.com/openrisc/or1k-gcc.git
	$(MAKE) fetchkernel$(KERNELVERSION)
	cd src; git clone git://git.musl-libc.org/musl
	cd src; git clone git://github.com/openrisc/or1ksim.git
	cd src/or1k-gcc; git checkout musl-4.9.1

fetchgnutoolchain:
	cd downloads; wget ftp://sourceware.org/pub/binutils/snapshots/binutils-@VERSION@.tar.bz2
	cd src; git clone git://github.com/openrisc/or1k-gcc.git
	$(MAKE) fetchkernel$(KERNELVERSION)
	cd src; git clone git://github.com/openrisc/or1ksim.git
	cd src; git clone git://github.com/openrisc/or1k-glibc.git

fetchkernel3:
	cd src; git clone git://github.com/skristiansson/linux.git

fetchkernel4:
	cd src; git clone git://github.com/openrisc/linux.git
	
precheck: 
	#toolchain_stage4
	#mkdir -p src/linux/arch/openrisc/support/initramfs/root
	#mkdir -p src/linux/arch/openrisc/support/initramfs/tmp
	#mkdir -p src/linux/arch/openrisc/support/initramfs/lib
	#mkdir -p src/linux/arch/openrisc/support/initramfs/usr/lib
	#cp -Pr $(SYSROOT)/lib/* src/linux/arch/openrisc/support/initramfs/lib/
	#cp -Pr $(SYSROOT)/usr/lib* src/linux/arch/openrisc/support/initramfs/usr/lib/
	#cp -Pr $(SYSROOT)/usr/lib/* src/linux/arch/openrisc/support/initramfs/usr/lib/
	#cd src/linux; make

uclibc_toolchain:
	$(MAKE) toolchain_binutils
	$(MAKE) toolchain_linux
	$(MAKE) toolchain_gcc1
	$(MAKE) toolchain_uclibc
	$(MAKE) toolchain_gcc2

musl_toolchain:
	mkdir -p $(SYSROOT)
	mkdir -p $(TOOLCHAIN_DIR)/$(TOOLCHAIN_TARGET)
	-ln -s . $(TOOLCHAIN_DIR)/$(TOOLCHAIN_TARGET)/usr
	$(MAKE) toolchain_binutils2
	$(MAKE) toolchain_gcc1
	$(MAKE) toolchain_linux
	$(MAKE) toolchain_musl
	$(MAKE) toolchain_gcc2

gnu_toolchain:
	mkdir -p $(SYSROOT)
	mkdir -p $(TOOLCHAIN_DIR)/$(TOOLCHAIN_TARGET)
	$(MAKE) toolchain_binutils2
	$(MAKE) toolchain_gcc1
	$(MAKE) toolchain_linux
	$(MAKE) toolchain_glibc
	$(MAKE) toolchain_gcc3

binutils_VERSION=-\@VERSION\@
toolchain_binutils2:
	$(call extractpatch,binutils,$(binutils_VERSION))
	#cd src/binutils; patch -Np1 -i ../../patches/binutils-patch.diff
	cd src/binutils; sed -i -e 's,MAKEINFO="$MISSING makeinfo",MAKEINFO=true,g' configure
	mkdir -p src/or1k-src-build
	rm -rf src/or1k-src-build/*
	cd src/or1k-src-build;../../src/binutils/configure \
	--disable-werror \
        --target=$(TOOLCHAIN_TARGET) \
        --prefix=$(TOOLCHAIN_DIR) \
	--with-sysroot
	cd src/or1k-src-build; make
	cd src/or1k-src-build; make install


toolchain_binutils:
	mkdir -p src/or1k-src-build
	rm -rf src/or1k-src-build/*
	cd src/or1k-src-build;../../src/or1k-src/configure \
        --target=$(TOOLCHAIN_TARGET) \
        --prefix=$(TOOLCHAIN_DIR) \
        --disable-shared \
        --disable-itcl \
        --disable-tk \
        --disable-tcl \
        --disable-winsup \
        --disable-libgui \
        --disable-rda \
        --disable-sid \
        --disable-sim \
        --disable-gdb \
        --with-sysroot \
        --disable-newlib \
        --disable-libgloss \
        --disable-werror \
        --without-docdir
	#cd src/or1k-src-build; echo "MAKEINFO = :" >> Makefile
	cd src/or1k-src-build; make
	cd src/or1k-src-build; make install

toolchain_linux:
	cd src/linux/; make ARCH=openrisc INSTALL_HDR_PATH=$(SYSROOT)/usr headers_install
	cd src/linux/; make ARCH=openrisc INSTALL_HDR_PATH=$(TOOLCHAIN_DIR)/$(TOOLCHAIN_TARGET) headers_install

toolchain_gcc1:
	cd src/or1k-gcc; git clean -d -f
	cd src/or1k-gcc; git reset --hard
	mkdir -p src/gcc-build
	rm -rf src/gcc-build/*
	cd src/gcc-build; CFLAGS="-O0 -g0" ../../src/or1k-gcc/configure \
	--target=$(TOOLCHAIN_TARGET) \
	--prefix=$(TOOLCHAIN_DIR) \
	--disable-libssp \
	--disable-nls \
	--enable-languages=c \
	--with-newlib \
	--disable-libgomp \
	--disable-libmudflap \
	--disable-shared \
	--disable-threads \
	--disable-decimal-float \
	--disable-libquadmath \
	--disable-libatomic \
	--disable-multilib	
	#cd src/gcc-build; echo "MAKEINFO = :" >> Makefile
	cd src/gcc-build; make
	cd src/gcc-build; make install

toolchain_musl:
	cd src/musl; make distclean
	cd src/musl; git clean -d -f
	cd src/musl; git reset --hard
	cd src/musl; ./configure \
	--enable-debug \
	--enable-optimize \
	CC=$(TOOLCHAIN_TARGET)-gcc \
 	--prefix=$(TOOLCHAIN_DIR)/$(TOOLCHAIN_TARGET)
	cd src/musl; make 
	cd src/musl; make install 
	#cp patches/stddef.h $(SYSROOT)/usr/include/


toolchain_uclibc:
	mkdir -p $(SYSROOT)/usr/bin
	cd src/uClibc-or1k; make clean
	cd src/uClibc-or1k; make distclean
	cd src/uClibc-or1k; make ARCH=or1k defconfig
	cp patches/CONFIG_UCLIBC src/uClibc-or1k/.config
	#sed -i~ -e "s;.*CROSS_COMPILER_PREFIX.*;CROSS_COMPILER_PREFIX=\"$(TOOLCHAIN_TARGET)-\";" src/uClibc-or1k/.config
	cd src/uClibc-or1k; make PREFIX=$(SYSROOT)
	cd src/uClibc-or1k; make PREFIX=$(SYSROOT) utils
	cd src/uClibc-or1k; make PREFIX=$(SYSROOT) install
	#ln -f -s ld-uClibc.so.0 $(SYSROOT)/lib/ld.so.1
	cp src/uClibc-or1k/utils/ldd $(SYSROOT)/usr/bin/

toolchain_glibc:
	#cd src/or1k-glibc; git reset --hard
	#cd src/or1k-glibc; git clean -d -f
	mkdir -p src/glibc-build
	rm -rf src/glibc-build/*
	cd src/glibc-build; 			\
	../or1k-glibc/configure $(CONFIG_HOST) 	\
	--with-headers=${SYSROOT}/usr/include --prefix=/usr	\
	--enable-kernel=3.0.0
	cd src/glibc-build; make \
	-C ${CURDIR}/src/or1k-glibc/locale \
	-r objdir="${CURDIR}/src/glibc-build" C-translit.h
	cd src/glibc-build; make 
	cd src/glibc-build; make install DESTDIR=$(SYSROOT)


toolchain_gcc2:
	rm -rf src/gcc-build/*
	cd src/gcc-build; ../../src/or1k-gcc/configure \
	--target=$(TOOLCHAIN_TARGET) \
	--prefix=$(TOOLCHAIN_DIR) \
	--enable-languages=c,c++,fortran \
	--disable-libmudflap \
	--disable-libsanitizer \
	--disable-multilib	\
	--disable-nls \
	--enable-shared=libstdc++,libgomp,libatomic,libsupc++ \
	--with-sysroot=$(SYSROOT)
	cd src/gcc-build; make
	cd src/gcc-build; make install
	rm -rf $(TOOLCHAIN_DIR)/lib/gcc/or1k-linux-musl/*/include-fixed/ 
	rm -rf $(TOOLCHAIN_DIR)/lib/gcc/or1k-linux-musl/*/include/stddef.h
	##cp -P $(TOOLCHAIN_DIR)/$(TOOLCHAIN_TARGET)/lib/libstdc* $(SYSROOT)/usr/lib/
	##cp -P $(TOOLCHAIN_DIR)/$(TOOLCHAIN_TARGET)/lib/libgcc* $(SYSROOT)/usr/lib/

#gcc2 vor glibc
toolchain_gcc3:
	rm -rf src/gcc-build/*
	cd src/gcc-build; ../../src/or1k-gcc/configure \
	--target=$(TOOLCHAIN_TARGET) \
	--prefix=$(TOOLCHAIN_DIR) \
	--enable-languages=c,c++ \
	--enable-threads=posix \
	--disable-libmudflap \
	--disable-libgomp \
	--disable-libsanitizer \
	--disable-multilib	\
	--disable-nls \
	--enable-vtable-verify	\
	--with-sysroot=$(SYSROOT)
	cd src/gcc-build; make
	cd src/gcc-build; make install
	##cp -P $(TOOLCHAIN_DIR)/$(TOOLCHAIN_TARGET)/lib/libstdc* $(SYSROOT)/usr/lib/
	##cp -P $(TOOLCHAIN_DIR)/$(TOOLCHAIN_TARGET)/lib/libgcc* $(SYSROOT)/usr/lib/

