gmp_VERSION = -6.0.0
mpfr_VERSION = -3.1.2
mpc_VERSION = -1.0.2
make_VERSION = -3.82
make_EXTRA_CONFIG = --disable-nls
buildtools: gmp mpfr mpc binutils gcc make
morebuildtools: libtool dejagnu

gmp mpfr mpc:
	$(call extractpatch,$@,$($@_VERSION))

gcc: 
	cd src/or1k-gcc; git clean -d -f
	cd src/or1k-gcc; git reset --hard
	#cd src/or1k-gcc; sed -i 's,-lgcc_s,--start-group -lgcc_eh -lgcc -lc --end-group,' gcc/gcc.c
	#cd src/or1k-gcc; sed -i 's,gcc_no_link=yes,gcc_no_link=no,' ./libstdc++-v3/configure
	#cd src/or1k-gcc; mv ./libstdc\+\+-v3/config/os/gnu-linux ./libstdc\+\+-v3/config/os/gnu-linux.org
	#cd src/or1k-gcc; cp -r ./libstdc\+\+-v3/config/os/generic ./libstdc\+\+-v3/config/os/gnu-linux
	#cd src/or1k-gcc; sed -i 's@\./fixinc\.sh@-c true@' gcc/Makefile.in
	cd src/or1k-gcc; find . -name "config.sub" -exec sed -i 's/linux-dietlibc/linux-musl/g' {} \;
	mkdir -p src/gcc-nativebuild
	rm -rf src/gcc-nativebuild/*
	ln -sf ../gmp src/or1k-gcc/gmp
	ln -sf ../mpfr src/or1k-gcc/mpfr
	ln -sf ../mpc src/or1k-gcc/mpc
	cd src/gcc-nativebuild; CC="$(TOOLCHAIN_TARGET)-gcc -D_GNU_SOURCE" CFLAGS="-O2" ../../src/or1k-gcc/configure \
	--target=$(TOOLCHAIN_TARGET) \
	--host=$(TOOLCHAIN_TARGET) \
	--prefix=/usr \
	--program-prefix=  \
	--disable-debug \
	--disable-libssp \
	--enable-shared=libstdc++,libgomp,libatomic,libsupc++ \
	--srcdir=../../src/or1k-gcc \
	--enable-languages=c,fortran,c++ \
	--enable-threads=posix \
	--disable-libquadmath \
	--disable-libmudflap \
	--disable-multilib \
	--disable-bootstrap \
	--disable-libsanitizer \
	--disable-nls \
	--disable-lto \
	--with-system-zlib \
	--disable-docs \
	--with-target-libiberty=no
	#cd src/gcc-nativebuild; echo "MAKEINFO = :" >> Makefile	
	cd src/gcc-nativebuild; make
	cd src/gcc-nativebuild; make DESTDIR=$(SYSROOT) install

binutils:
	$(call extractpatch,binutils,$(binutils_VERSION))
	#cd src/binutils; patch -Np1 -i ../../patches/binutils-patch.diff
	rm -rf src/build-or1k-src/*
	mkdir -p src/build-or1k-src
	cd src/build-or1k-src;../../src/binutils/configure \
	--target=$(TOOLCHAIN_TARGET) \
	--host=$(TOOLCHAIN_TARGET) \
	--prefix=/usr \
	--program-prefix= \
	--enable-shared \
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
	#cd src/build-or1k-src; echo "MAKEINFO = :" >> Makefile
	cd src/build-or1k-src; make tooldir=/usr
	#cd src/build-or1k-src; echo "install-strip: install" >> readline/Makefile
	#cd src/build-or1k-src; echo "install-strip: install" >> utils/Makefile
	cd src/build-or1k-src; STRIPPROG="$(TOOLCHAIN_TARGET)-strip" make tooldir=/usr DESTDIR=$(SYSROOT) install

gdb_VERSION = -7.8
gdb_EXTRA_CONFIG = --disable-werror --with-system-zlib=yes --disable-sim --disable-tui
gdb:
	#$(call extractpatch,$@,$($@_VERSION))
	#sed -i 's/or32/or1k/g' src/gdb/bfd/config.bfd
	#sed -i 's/or32/or1k/g' src/gdb/readline/support/config.guess
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	#cd src/$@; make install DESTDIR=$(SYSROOT)

libtool_VERSION = -2.4.2
make libtool:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)

expect_VERSION = 5.45
expect_EXTRA_CONFIG = --enable-shared --sysconfdir=/etc --with-tcl=$(SYSROOT)/usr/lib --with-tclinclude=$(SYSROOT)/usr/include --with-tcllib=$(SYSROOT)/usr/lib
expect:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; cd src/$@; patch -p1 < ../../patches/expect/expect-0001-enable-cross-compilation.patch
	cd src/$@; cd src/$@; patch -p1 < ../../patches/expect/expect-0002-allow-tcl-build-directory.patch
	cd src/$@; autoreconf
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; sed -i 's; -L/usr/lib;;' Makefile
	cd src/$@; make
	cd src/$@; make install-binaries DESTDIR=$(SYSROOT)


dejagnu_VERSION = -1.5.1
dejagnu:
	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; CFLAGS="-O2 $($@_EXTRA_CFLAGS)" ./configure $(CONFIG_HOST) $($@_EXTRA_CONFIG)
	cd src/$@; make
	cd src/$@; make install DESTDIR=$(SYSROOT)


