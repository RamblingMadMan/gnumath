# GNU Math Libraries

This repository contains copies of the full source and includes build scripts for the following libraries:

- [GNU MP](https://gmplib.org/)
- [GNU MPFR](https://www.mpfr.org/)

## Building

### Desktop

Use this repo as you would any other CMake project and link the targets `gnumath::gmp`, `gnumath::gmpxx` and/or `gnumath::mpfr`.

### Android

Run the included `build-android.sh` script. This will create `gnumath-aarch64-linux-android29.tar.gz` in the directory the script is run.
