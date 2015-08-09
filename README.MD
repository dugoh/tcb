These scripts should help to build the experimental toolchain, programs and libraries for the openrisc or1k processor.
The final goal is to build an bootable image with a number of tools available for further development.

Parts are based on the book "Linux from Scratch"


TOOLCHAIN
---------

Following tools are required to build the toolchain
gcc, g++, make, texinfo, libmpfr-dev, libgmp-dev, libmpc-dev, flex, bison, bc

1. Edit the top lines of the Makefile
2. Execute
	make info (check and change in Makefile)	
	make init
	make fetchtoolchain
	make musl_toolchain

To work with this toolchain directly execute
	make env
and execute the commands printed

KERNEL
------
Execute following commands
	make linux

Progs and Libs
--------------

To get a list of available programs and libraries look at the target in scripts/progs.make
	make fetchprogs (unfortunately this does not work at the moment. You have to download the programs by yourself in the downloads folder. Files can be found under jor1k.com/downloads/)
	make libs
	make progs
	make graphics

Native Building Tools
---------------------
	make buildtools

Network 
-------
	make network


DirectFB
--------
	make libs (if not already done so)
	make progs (if not already done so)
	make graphics (if not already done so)
	make buildtools (if not already done so)
	make DirectFB 
	make DirectFB_Examples

X11
---
	make libs (if not already done so)
	make progs (if not already done so)
	make graphics (if not already done so)
	make buildtools (if not already done so)
	make xprotoheaders
	make xlibs
	make xlibs2
	make Mesa
	make xfonts
	make xorg-server
	make xapps

Image
-----

Execute following commands
	make buildimage
	
