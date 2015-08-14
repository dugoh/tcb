These scripts should help to build a toolchain, programs and libraries for the openrisc or1k processor. The final goal is to build a filesystem for jor1k with a number of tools for simulating history.

Initialy Taken from http://jor1k.com/downloads/or1k-toolchain.tar.bz2


TOOLCHAIN
---------

1. Get some required tools
```sh
	apt-get install -y build-essential
	apt-get install gawk
	apt-get install -y gcc
	apt-get install -y g++
	apt-get install -y make
	apt-get install -y autoconf
	apt-get install -y libtool
	apt-get install -y texinfo
	apt-get install -y libmpfr-dev
	apt-get install -y libgmp3-dev
	apt-get install -y libmpc-dev
	apt-get install -y flex
	apt-get install -y bison
	apt-get install -y bc
	apt-get install -y git
	apt-get install -y lynx
```
2. Get this
```sh
	lynx -source https://github.com/dugoh/tcb/archive/master.tar.gz|gunzip -c |tar -xvf -
```
3. Execute
```sh
	cd tcb-master
	make info            #check and change in Makefile if needed
	make init
	make fetchtoolchain
	make musl_toolchain
```

To work with this toolchain directly execute
```sh
	make env |grep "^export" >environment
	. ./environment
```

KERNEL
------
Execute following commands
```sh
	make linux
```

Progs and Libs
--------------

To get a list of available programs and libraries look at the target in scripts/progs.make
```sh
	wget -nd -nc -P downloads -r -np http://jor1k.com/downloads/
	make libs
	make progs
	make graphics
```

Native Building Tools
---------------------
```sh
	make buildtools
```

Network 
-------
```sh
	make network
```


DirectFB
--------
```sh
	make libs            #if not already done so
	make progs           #if not already done so
	make graphics        #if not already done so
	make buildtools      #if not already done so
	make DirectFB 
	make DirectFB_Examples
```

X11
---
```sh
	make libs            #if not already done so
	make progs           #if not already done so
	make graphics        #if not already done so
	make buildtools      #if not already done so
	make xprotoheaders
	make xlibs
	make xlibs2
	make Mesa
	make xfonts
	make xorg-server
	make xapps
```
Image
-----

Execute following commands
```sh
	make buildimage
```
