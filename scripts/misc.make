startqemueasy:
	qemu-system-or32 -nographic -kernel src/linux/vmlinux

startqemu: 
	qemu-system-or32 -m 64 -nographic -kernel src/linux/vmlinux

startor1keasy: 
	sim -f patches/or1ksim.cfg src/linux/vmlinux

startor1k:
	sim -f patches/or1ksim.cfg src/linux/vmlinux


#1. Generate a or1k-linux-musl-run executable in /opt/cross/or.../bin
#SYSROOT=~/jor1k-sysroot/jor1k-sysroot/sysroot
#b=$(basename $1)
#d=$(dirname $1)
#cp $1 $SYSROOT
#chroot $SYSROOT /usr/bin/qemu-or1k-static $b
#exitcode=$?
#rm $SYSROOT/$b
#cp $SYSROOT/*.gcda $d
#exit $exitcode

#maybe export DEJAGNU=~/patches/site.exp 

gcctestsuite: 
	cp patches/or1k-linux-musl-run $(TOOLCHAIN_DIR)/bin/$(TOOLCHAIN_TARGET)-run
	chmod u+x $(TOOLCHAIN_DIR)/bin/$(TOOLCHAIN_TARGET)-run
	cp patches/or1k-sim.exp /usr/local/share/dejagnu/baseboards/
	#cd src/gcc-build; make check RUNTESTFLAGS="execute.exp --target_board=or1k-sim" 
	#cd src/gcc-build; make check RUNTESTFLAGS="dg.exp --target_board=or1k-sim" 
	#cd src/gcc-build; make -k check RUNTESTFLAGS=" --target_board=or1k-sim"
	cd src/gcc-build; make -k check RUNTESTFLAGS=" --target_board=or1k-sim" 

ffitestsuite: 
	cd src/libffi; make install DESTDIR=/root/jor1k-sysroot/jor1k-sysroot/sysroot
	or1k-linux-musl-gcc ffitest2.c -lffi -Isysroot/usr/lib/libffi-3.0.13/include -o /root/jor1k-sysroot/jor1k-sysroot/sysroot/ffitest2
	cp patches/or1k-sim.exp /usr/local/share/dejagnu/baseboards/
	cd src/libffi;  DEJAGNU="$PWD/patches/site.exp" make check RUNTESTFLAGS="--target_board=or1k-sim" CC=or1k-linux-musl-gcc
	#chroot /root/jor1k-sysroot/jor1k-sysroot/sysroot /usr/bin/qemu-or1k-static -E PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin,TERM=linux bin/sh

binutilstestsuite: 
	cp patches/or1k-sim.exp /usr/local/share/dejagnu/baseboards/
	cd src/or1k-src-build; DEJAGNU="$PWD/patches/site.exp" make check RUNTESTFLAGS="--target_board=or1k-sim" CC=or1k-linux-musl-gcc
	#chroot /root/jor1k-sysroot/jor1k-sysroot/sysroot /usr/bin/qemu-or1k-static -E PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin,TERM=linux bin/sh

