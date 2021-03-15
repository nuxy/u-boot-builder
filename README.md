# U-Boot builder

Create a [U-Boot](https://www.denx.de/wiki/U-Boot) loader for your ARM embedded hardware.

## Dependencies

- [Docker](https://docs.docker.com/get-docker)

## Getting Started

```txt
Usage: build.sh [--config=] [--platform=] [--release=] [--aarch=64]
Options:
  --config   : Board configuration name (e.g. <board_name>_defconfig or menuconfig)
  --platform : Board platform name (optional, to build Arm Trusted Firmware)
  --release  : U-Boot release tag (optional)
  --aarch    : Compile SoC architecture (32/64, default: 32)
```

### Examples

Compile for [SUNXI](https://linux-sunxi.org) [H3](https://linux-sunxi.org/H3) SoC series ([NanoPi NEO](https://wiki.friendlyarm.com/wiki/index.php/NanoPi_NEO))

    $ ./build.sh --config nanopi_neo_defconfig

.. [H5](https://linux-sunxi.org/H5) and [A64](https://linux-sunxi.org/A64) SoC series ([NanoPi NEO2](https://wiki.friendlyarm.com/wiki/index.php/NanoPi_NEO2))

    $ ./build.sh --config nanopi_neo2_defconfig --platform sun50i_a64 --aarch 64

### Launch the interactive set-up

    $ ./build.sh --config menuconfig

## References

- [Board configurations](https://github.com/u-boot/u-boot/configs)
- [Platforms](https://github.com/ARM-software/arm-trusted-firmware/tree/eeb77da64684424ef275330e3e15d8350ecc1b07/docs/plat)
- [Releases](https://github.com/u-boot/u-boot/releases)

## License and Warranty

This package is distributed in the hope that it will be useful, but without any warranty; without even the implied warranty of merchantability or fitness for a particular purpose.

*U-Boot builder* is provided under the terms of the [MIT license](http://www.opensource.org/licenses/mit-license.php)

## Maintainer

[Marc S. Brooks](https://github.com/nuxy)
