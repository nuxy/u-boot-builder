# U-Boot docker

Create a [U-Boot](https://www.denx.de/wiki/U-Boot) loader for your embedded hardware.

## Dependencies

- [Docker](https://docs.docker.com/get-docker)

## Getting Started

    $ docker build --build-arg CONFIG=<board_name>_defconfig --build-arg VERSION=v2020.04 --tag=das:u-boot .

### Compile using build-time arguments

    $ docker run -it -v $PWD:/board --rm das:u-boot

### Launch the interactive set-up

    $ docker run -it -v $PWD:/board -v /tmp/.X11-unix:/tmp/.X11-unix --rm das:u-boot

## References

- [Board configurations](https://github.com/u-boot/u-boot)
- [Releases](https://github.com/u-boot/u-boot/releases)

## License and Warranty

This package is distributed in the hope that it will be useful, but without any warranty; without even the implied warranty of merchantability or fitness for a particular purpose.

*U-Boot docker* is provided under the terms of the [MIT license](http://www.opensource.org/licenses/mit-license.php)

## Maintainer

[Marc S. Brooks](https://github.com/nuxy)
