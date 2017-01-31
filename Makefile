# --------------------------------------
TOOLCHAIN = gnu
#TOOLCHAIN = musl
KERNELVERSION = 4
#KERNELVERSION = 3
# --------------------------------------
TOOLCHAIN_TARGET = or1k-linux-$(TOOLCHAIN)
TOOLCHAIN_DIR = ${HOME}/opt/cross/$(TOOLCHAIN_TARGET)

SYSROOT := $(CURDIR)/sysroot
JOR1KSYSROOT := $(CURDIR)/jorik-sysroot
PATH := $(TOOLCHAIN_DIR)/bin:$(PATH)
PARENT_DIR = $(lastword $(subst /, ,$(PWD)))

#for all the packages
PKG_CONFIG_DIR := 
PKG_CONFIG_PATH :=  
PKG_CONFIG_LIBDIR := ${SYSROOT}/usr/lib/pkgconfig:${SYSROOT}/usr/share/pkgconfig
PKG_CONFIG_SYSROOT_DIR := $(SYSROOT)

CMAKE_SYSTEM_NAME := Linux
CMAKE_C_COMPILER := $(TOOLCHAIN_TARGET)-gcc
CMAKE_CXX_COMPILER := $(TOOLCHAIN_TARGET)-g++

export SYSROOT
export JOR1KSYSROOT
export PATH

export PKG_CONFIG_DIR
export PKG_CONFIG_PATH
export PKG_CONFIG_LIBDIR
export PKG_CONFIG_SYSROOT_DIR

export CMAKE_SYSTEM_NAME
export CMAKE_C_COMPILER
export CMAKE_CXX_COMPILER

deletedir = if test -d $(1); then 				\
	rm -rf $(1)/ $(1)/.??* $(1)/.[^.] ;			\
	fi;


CONFIG_HOST = --host=$(TOOLCHAIN_TARGET) --prefix=/usr


extractpatch = 							\
	$(call deletedir,src/$(1))					\
	if test -e downloads/$(1)$(2).tar.gz; then 			\
		tar -C src -xzf downloads/$(1)$(2).tar.gz;		\
	else								\
	if test -e downloads/$(1)$(2).tar.bz2; then			\
		tar -C src -xjf downloads/$(1)$(2).tar.bz2;		\
	else								\
	if test -e downloads/$(1)$(2).tar.xz; then			\
		tar -C src -xJf downloads/$(1)$(2).tar.xz;		\
	else								\
		echo Error: Could not find file downloads/$(1)$(2).tar.gz or downloads/$(1)$(2).tar.bz2;			\
		exit 1;														\
	fi;				\
	fi;				\
	fi;									\
	mv src/$(1)$(2) src/$(1);					\
	cd src/$1; find . -name "config.sub" -exec sed -i 's/or32/or1k/g' {} \;; \
	cd src/$1; find . -name "config.sub" -exec sed -i 's/dietlibc/musl/g' {} \;;


#Naming our phony targets, targets which dont create files
.PHONY: help info env dep test clean toolchainpull toolchaincheck

help:
	@echo "  help: shows this help screen"
	@echo "  info: shows some variables used (please change the Makefile)"
	@echo "  env: prints some global variables. Execute this if you want to compile by your own"
	@echo "Please take a look in README.MD for all supported commands"


info:
	@echo "TOOLCHAIN_DIR=$(TOOLCHAIN_DIR)"
	@echo "PATH = $(PATH)"
	@echo "SYSROOT = $(SYSROOT)"
	@echo "JOR1KSYSROOT = $(JOR1KSYSROOT)"
	@echo "SRCDIR = $(CURDIR)"
	@echo "PARENT_DIR = $(PARENT_DIR)"
	@echo "KERNELVERSION = $(KERNELVERSION)"

dep:
	@echo "mandatory: gcc make flex bison" 
	@echo "other: e2fsprogs python qemu or1ksim"

env:
	@echo "#===================================================="
	@echo "# Execute following commands in your shell"
	@echo "#===================================================="
	@echo "export PATH=$(PATH)"
	@echo "export SYSROOT=$(SYSROOT)"
	@echo "export JOR1KSYSROOT=$(JOR1KSYSROOT)"
	@echo "export PKG_CONFIG_DIR=$(PKG_CONFIG_DIR)"
	@echo "export PKG_CONFIG_PATH=$(PKG_CONFIG_PATH)"
	@echo "export PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR)"
	@echo "export PKG_CONFIG_SYSROOT_DIR=$(PKG_CONFIG_SYSROOT_DIR)"
	@echo "#===================================================="

test:
	#check if path is working
	$(CC) -v

init:
	mkdir -p src
	mkdir -p downloads
	mkdir -p $(TOOLCHAIN_DIR)
	mkdir -p $(SYSROOT)
	mkdir -p $(SYSROOT)/usr/bin
	mkdir -p $(SYSROOT)/usr/lib
	mkdir -p $(JOR1KSYSROOT)

#build toolchain
include scripts/toolchain.make

#build tools to compile your own stuff on the target
include scripts/build.make

#scripts to create the ext2 image
include scripts/image.make

#fetch files not in the toolchain
include scripts/fetch.make

# several important programs and libraries
include scripts/progs.make

# X11 libraries
include scripts/X.make

# Emulators
include scripts/native.make

# Misc stuff
include scripts/misc.make

# packages
include scripts/filesystem.make

fsilinux:
	#cd src/linux; cp ../../patches/linux/fsi.c sound/soc/sh/
	cd src/linux; cp ../../patches/linux/dummy_sound.c sound/drivers/dummy.c
	cd src/linux; make ARCH=openrisc
	cd src/linux; $(TOOLCHAIN_TARGET)-objcopy -O binary vmlinux vmlinux.bin
	cd src/linux; bzip2 -f --best vmlinux.bin

linux:
	#cd src/linux; git clean -d -x -f
	cd src/linux; git reset --hard
	#cd src/linux; git checkout smp
	cd src/linux; git checkout 
	cd src/linux; make clean
	cd src/linux; make distclean
	cd src/linux; make ARCH=openrisc defconfig
	#cd src/linux; git apply ../../patches/linux/move_protection_fault_detection_to_do_page_fault.patch
	cd src/linux; git apply ../../patches/linux/move_protection_fault_new.patch
	#cd src/linux; git apply ../../patches/linux/Idle_hack.patch
	cd src/linux; git checkout arch/openrisc/mm/fault.c
	cd src/linux; git apply ../../patches/linux/linux-fault-print.diff
	cd src/linux; git apply ../../patches/linux/linux-trap.diff
	cd src/linux; git apply ../../patches/linux/linux-ptrace-peekuser.diff
	cd src/linux; git apply ../../patches/linux/linux-ptrace-headers.diff
	cp patches/linux/or1ksim.dts src/linux/arch/openrisc/boot/dts
	cp patches/linux/opencores-kbd.c src/linux/drivers/input/keyboard/
	cp patches/linux/CONFIG_LINUX$(KERNELVERSION) src/linux/.config
	#sed -i~ -e "s/ifdef CONFIG_WISHBONE/ifndef CONFIG_WISHBONE/g" src/linux/drivers/net/ethernet/ethoc.c
	sed -i~ -e "s/or32/or1k/g" src/linux/arch/openrisc/kernel/vmlinux.lds.S
	sed -i~ -e "s/depends on ARCH_LPC32XX//g" src/linux/drivers/input/touchscreen/Kconfig
	sed -i~ -e "s/depends on ARCH_LPC32XX//g" src/linux/drivers/rtc/Kconfig
	sed -i~ -e "s/default 100 if HZ_100/default 50 if HZ_100/g" src/linux/kernel/Kconfig.hz
	sed -i~ -e "s/pr_notice(\"random: %s/\/\//g" src/linux/drivers/char/random.c
	sed -i~ -e "/depends on CPU_SUBTYPE_SH7760/d" src/linux/sound/soc/sh/Kconfig
	sed -i~ -e "/depends on SUPERH/d" src/linux/sound/soc/sh/Kconfig
	sed -i~ -e "s/8000_96000/11025/" src/linux/sound/soc/sh/fsi.c
	cd src/linux; mkdir -p drivers/nullmodem/
	wget -nc -P src/linux/drivers/nullmodem/ https://github.com/dugoh/nullmodem/raw/master/nullmodem.c
	cd src/linux; echo 'obj-$$(CONFIG_NULLMODEM) += nullmodem.o' >drivers/nullmodem/Makefile
	cd src/linux; printf "config NULLMODEM\n\ttristate \"Virtual nullmodem driver\"\n\thelp\n\t  Creates pairs of virtual COM ports that are connected to each other.\n\t  The name of the devices are /dev/nmpX, where X is the number of the COM port.\n" >drivers/nullmodem/Kconfig
	cd src/linux; echo 'obj-$$(CONFIG_NULLMODEM)\t\t+= nullmodem/' >> drivers/Makefile
	cd src/linux; sed -i~ -e's/endmenu/source "drivers\/nullmodem\/Kconfig"\n\nendmenu/' drivers/Kconfig
	cd src/linux; echo CONFIG_NULLMODEM=y >>.config
	cd src/linux; make ARCH=openrisc CONFIG_CROSS_COMPILE="$(TOOLCHAIN_TARGET)-"
	cd src/linux; $(TOOLCHAIN_TARGET)-objcopy -O binary vmlinux vmlinux.bin
	cd src/linux; bzip2 -f --best vmlinux.bin
	cd src/linux; cp -p vmlinux.bin.bz2 $(JOR1KSYSROOT)/

baselinux:
	cd src/linux; git clean -d -x -f
	cd src/linux; git reset --hard	
	cd src/linux; make clean
	cd src/linux; make distclean
	cd src/linux; make ARCH=openrisc defconfig
	sed -i~ -e "s/or32/or1k/g" src/linux/arch/openrisc/kernel/vmlinux.lds.S
	sed -i~ -e "s/or32-linux/$(TOOLCHAIN_TARGET)/g" src/linux/.config
	cd src/linux; make ARCH=openrisc
	cd src/linux; $(TOOLCHAIN_TARGET)-objcopy -O binary vmlinux vmlinux.bin
	cd src/linux; bzip2 -f --best vmlinux.bin


archive:
	tar -cvjf or1k-toolchain.tar.bz2 -C ../ $(PARENT_DIR)/Makefile $(PARENT_DIR)/README.MD $(PARENT_DIR)/patches $(PARENT_DIR)/scripts $(PARENT_DIR)/tools

sysrootarchive: 
	#mkdir -p jor1k-sysroot
	#cd jor1k-sysroot; rm -f *
	#cd jor1k-sysroot; wget http://openrisc.debian.net/qemu-or1k-static
	#cd jor1k-sysroot; chmod u+x qemu-or1k-static
	#cp patches/binfmt-qemu-or1k jor1k-sysroot/
	#cd jor1k-sysroot; ln -s /opt/or1k/or1k-linux/sys-root2 sysroot
	#tar -cvJf jor1k-sysroot.tar.xz jor1k-sysroot/qemu-or1k-static jor1k-sysroot/binfmt-qemu-or1k  jor1k-sysroot/sysroot/*/
	
clean:
	-rm *.done
