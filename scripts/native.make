or1ksim:
	cd src/or1ksim; git reset --hard
	cd src/or1ksim; ./configure
	#cd src/or1ksim; git apply ../../patches/0002-Enable-direct-access-to-ata-devices.patch
	cd src/or1ksim; make
	cd src/or1ksim; make install


#for the blueCmd-qemu-version
#qemu_VERSION = -1.6.0
#qemu:
#	$(call extractpatch,$@,$($@_VERSION))
	cd src/$@; ./configure 			\
		---static 			\
		--target-list=or32-linux-user 	\
		--disable-glusterfs		\
		--disable-libssh2		\
		--disable-spice			\
		--disable-libiscsi		\
		--disable-smartcard-nss		\
		--disable-libusb		\
		--disable-usb-redir		\
		--disable-guest-agent		\
		--disable-seccomp
	cd src/$@; make ( last link needs -lrt)
#	cd src/$@; make install

or1kdejagnu:
	cd src/or1k-dejagnu; ./configure
	cd src/or1k-dejagnu; make
	cd src/or1k-dejagnu; make install

