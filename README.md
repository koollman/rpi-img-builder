## Musicbox

***Turn the Pi into a headless Pandora Music Player / Bluetooth Audio Receiver***

`Target Device: Raspberry Pi 3A+`

***Applications:***
* Pianobar ... [Console client](https://github.com/PromyLOPh/pianobar)
* Patiobar ... [Web interface](https://github.com/pyavitz/Patiobar)
* Bluez

***Recommend:***
* SSH Button ... [Android App](https://play.google.com/store/apps/details?id=com.pd7l.sshbutton&hl=en_US)
* Amp Modules ... [PAM8403](https://www.amazon.com/PAM8403-Channel-Digital-Amplifier-Potentionmeter/dp/B01MYTZGYM) [PAM8406](https://www.ebay.com/itm/Amplifier-Board-Class-D-Audio-5W-5W-Module-Dual-Channel-PAM8406-DIY-Stereo-Mini/313153265326?_trkparms=aid%3D777001%26algo%3DDISCO.FEED%26ao%3D1%26asc%3D225074%26meid%3D56ccad57a0b3470196bc7664442aad56%26pid%3D100651%26rk%3D1%26rkt%3D1%26mehot%3Dnone%26itm%3D313153265326%26pmt%3D1%26noa%3D1%26pg%3D2380057%26algv%3DPersonalizedTopicsRefactor%26brand%3D&_trksid=p2380057.c100651.m4497&_trkparms=pageci%3A7e3b7455-d363-11ea-ac52-ae0bcbae8747%7Cparentrq%3Aa65578871730a45e5bf83bf0ffd9ca44%7Ciid%3A1)

### Headless Usage:
```sh
Create keygen: ssh-keygen
Copy to target device: ssh-copy-id user@ipaddress
```
```sh
nano ~/.ssh/config
Host musicbox
        User username
        HostName ipaddress
        Port 22
        ForwardX11 no
```
```sh
nano ~/.config/musicbox_func.txt
start (){
ssh musicbox '~/bin/start'
}
stop (){
ssh musicbox '~/bin/stop'
}
play (){    # play/pause
ssh musicbox '~/bin/play'
}
next (){
ssh musicbox '~/bin/next'
}
volup (){
ssh musicbox '~/bin/volup'
}
voldn (){
ssh musicbox '~/bin/voldn'
}
mute (){
ssh musicbox '~/bin/mute'
}
unmute (){
ssh musicbox '~/bin/unmute'
}
```
```sh
nano ~/.bashrc
source  ~/.config/musicbox_func.txt
```
You can also map a bluetooth remote or controller and use the `~/bin/scripts` to control the Pi / Pianobar.
The following [link](https://raspberry-valley.azurewebsites.net/Map-Bluetooth-Controller-using-Python/) explains the basics.

---

## Debian Image Builder for the Raspberry Pi 

The boards that are currently supported are;
* Raspberry Pi 4B (bcm2711)
* Raspberry Pi 3A/B/+ (bcm2710)

## Dependencies

In order to install the required dependencies, run the following command:

```
sudo apt install build-essential bison bc git dialog patch dosfstools zip unzip qemu debootstrap \
                 qemu-user-static rsync kmod cpio flex libssl-dev libncurses5-dev parted fakeroot \
                 swig crossbuild-essential-arm64
```

This has been tested on an AMD64/x86_64 system running on [Debian Buster](https://www.debian.org/releases/buster/debian-installer/).

Alternatively, you can run the command `make install-depends` in this directory.

## Instructions

#### Install dependencies

```sh
make install-depends        # Cross compile
make install-native-depends # Native compile
```

#### Menu interface

```sh
make config     # Create user data file
make menu       # Open menu interface
make dialogrc   # Set builder theme (optional)
```
#### Config Menu

```sh
Username:       # Your username
Password:       # Your password
Debian:         # Supported: buster & unstable (unstable at your own risk)
Branch:         # Selected kernel branch
Edge Branch:    # 1 for any branch above 5.4.y
Menuconfig:     # 1 to run kernel menuconfig
Crosscompile:   # 1 to cross compile | 0 to native compile
```
#### User defconfig

```sh
nano userdata.txt
# place config in defconfig directory
custom_defconfig=1
MYCONFIG="nameofyour_defconfig"
```
#### Miscellaneous

```sh
make cleanup    # Clean up image errors
make purge      # Remove tmp directory
make commands   # List legacy commands
make helper     # Reduce the time it takes to create a new image
```

## Command list (legacy)

#### Raspberry Pi 4B

```sh
# AARCH64
make kernel
make image
make all
```

#### Raspberry Pi 3A/B/+

```sh
# AARCH64
make rpi3-kernel
make rpi3-image
make rpi3-all
```
#### Root Filesystems

```sh
make rootfs   # arm64
```

## Usage
#### /boot/rename_to_credentials.txt
```sh
Rename file to credentials.txt and input your wifi information.

SSID=" "			# Service set identifier
PASSKEY=" "			# Wifi password
COUNTRYCODE=" "			# Your country code

# set static ip
MANUAL=n			# Set to y to enable a static ip
IPADDR=" "			# Static ip address
NETMASK=" "			# Your Netmask
GATEWAY=" "			# Your Gateway
NAMESERVERS=" "			# Your preferred dns

For headless use: ssh user@ipaddress

Note:
You can also mount the ROOTFS partition and edit the following
files, whilst leaving rename_to_credentials.txt untouched.

/etc/opt/interfaces.manual
/etc/opt/wpa_supplicant.manual
```

#### Using deb-eeprom and [usb_storage.quirks](https://github.com/pyavitz/rpi-img-builder/issues/17)

```sh
Raspberry Pi 4B EEPROM Helper Script
Usage: deb-eeprom -opt

   -v       Edit version variable
   -U       Upgrade eeprom package
   -w       Setup and install usb boot
   -u       Update script

```

#### Using fetch
```sh
Fetch, Linux kernel installer for the Raspberry Pi Image Builder
Usage: fetch -opt

   -1	    Linux 4.19.y LTS
   -2       Linux 5.4.y LTS
   -3       Linux Stable Branch
   -u       Update Fetch
   
fetch -h will list available options and kernel revisions
```
#### Simple wifi helper
```sh
swh -h

   -s       Scan for SSID's
   -u       Bring up interface
   -d       Bring down interface
   -r       Restart interface
   -W       Edit wpa supplicant
   -I       Edit interfaces
```

---

### Support

Should you come across any bugs, feel free to either open an issue on GitHub or talk with us directly by joining our channel on Freenode; [`#debianarm-port`](irc://irc.freenode.net/#debianarm-port)
