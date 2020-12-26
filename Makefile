# menu
MENU=./lib/dialog/menu
CONF=./lib/dialog/config
DIALOGRC=$(shell cp -f lib/dialogrc ~/.dialogrc)

# rootfs
RFSV8=./scripts/rootfsv8
ROOTFSV8=sudo ./scripts/rootfsv8

# kernel & u-boot
SELECT=./scripts/select
XLINUX=./scripts/linux
LINUX=sudo ./scripts/linux
XUBOOT=./scripts/uboot
UBOOT=sudo ./scripts/uboot

# stages
DEB=./scripts/debian-stage1
DEBIAN=sudo ./scripts/debian-stage1
DEBSTG2=./scripts/debian-stage2

# choose distribution
CHOOSE=./scripts/choose

# clean
CLN=./scripts/clean
CLEAN=sudo ./scripts/clean

# purge
PURGE=$(shell sudo rm -fdr sources)
PURGEALL=$(shell sudo rm -fdr sources output)

# help
XCHECK=./scripts/check
CHECK=./scripts/check


help:
	@echo
	@echo "\e[1;31mRaspberry Pi Image Builder\e[0m"
	@echo
	@echo "\e[1;37mUsage:\e[0m "
	@echo
	@echo "  make ccompile          Install all dependencies"
	@echo "  make ncompile          Install native dependencies"
	@echo "  make config            Create user data file"
	@echo "  make menu              User menu interface"
	@echo "  make cleanup           Clean up image errors"
	@echo "  make purge             Remove source directory"
	@echo "  make purge-all         Remove source and output directory"
	@echo "  make commands          List legacy commands"
	@echo
	@echo "For details consult the \e[1;37mREADME.md\e[0m"
	@echo

commands:
	@echo
	@echo "Boards:"
	@echo
	@echo "  bcm2711                 Raspberry Pi 4B"
	@echo
	@echo "bcm2711:"
	@echo " "
	@echo "  make all                U-boot (if selected) > Kernel > rootfs > image"
	@echo "  make uboot              Builds u-boot"
	@echo "  make kernel             Builds linux kernel"
	@echo "  make image              Make bootable image"
	@echo
	@echo "Root filesystem:"
	@echo
	@echo "  make rootfs		  arm64"
	@echo
	@echo "Miscellaneous:"
	@echo
	@echo "  make dialogrc		  Set builder theme"
	@echo "  make check		  Shows latest revision of selected branch"
	@echo

# aarch64
ccompile:
	# Install all dependencies
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted device-tree-compiler \
	libfdt-dev python3-distutils python3-dev swig fakeroot lzop lz4 \
	aria2 pv toilet figlet crossbuild-essential-arm64 gcc-arm-none-eabi \
	distro-info-data lsb-release xz-utils

ncompile:
	# Install all dependencies
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted device-tree-compiler \
	libfdt-dev python3-distutils python3-dev swig fakeroot lzop lz4 \
	aria2 pv toilet figlet gcc-arm-none-eabi distro-info-data lsb-release \
	xz-utils

# Raspberry Pi 4 | aarch64
all:
	# Reading user data file ...
	@chmod +x ${SELECT}
	@${SELECT}

uboot:
	# U-boot | aarch64
	@ echo bcm2711 > soc.txt
	@chmod +x ${XUBOOT}
	@${UBOOT}

kernel:
	# Linux | aarch64
	@ echo bcm2711 > soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}

image:
	# Making bootable image
	@ echo bcm2711 > soc.txt
	@chmod +x ${CHOOSE}
	@${CHOOSE}

foundation:
	# RPi4B | aarch64
	# - - - - - - - -
	#
	# Building linux
	@ echo bcm2711 > soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	# Making bootable image
	@ echo bcm2711 > soc.txt
	@chmod +x ${CHOOSE}
	@${CHOOSE}
	
traditional:
	# RPi4B | aarch64
	# - - - - - - - -
	#
	# Building uboot
	@ echo bcm2711 > soc.txt
	@chmod +x ${XUBOOT}
	@${UBOOT}
	# Building linux
	@ echo bcm2711 > soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	# Making bootable image
	@ echo bcm2711 > soc.txt
	@chmod +x ${CHOOSE}
	@${CHOOSE}

# rootfs
rootfs:
	# ROOTFS
	@chmod +x ${RFSV8}
	@${ROOTFSV8}

# clean and purge
cleanup:
	# Cleaning up
	@chmod +x ${CLN}
	@${CLEAN}

purge:
	# Removing source directory
	@${PURGE}

purge-all:
	# Removing source and output directory
	@${PURGEALL}

# menu
menu:
	# User menu interface
	@chmod +x ${MENU}
	@${MENU}
config:
	# User config menu
	@chmod go=rx files/scripts/*
	@chmod go=r files/misc/*
	@chmod go=r files/rules/*
	@chmod go=r files/users/*
	@chmod +x ${CONF}
	@${CONF}

# miscellaneous
dialogrc:
	# Builder theme set
	@${DIALOGRC}

check:
	# Check kernel revisions
	@chmod +x ${XCHECK}
	@${CHECK}

# raspberry pi 4 select
select:
	# Selecting kernel
	@chmod +x ${SELECT}
	@${SELECT}

# distros
debianos:
	# Debian
	@chmod +x ${DEB}
	@chmod +x ${DEBSTG2}
	@${DEBIAN}
