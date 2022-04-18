#!/bin/bash

# exit on errors
set -e

# https://stackoverflow.com/a/246128
SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

ANDROID_API=29
ANDROID_TRIPLET="aarch64-linux-android"
ANDROID_NDK_VERSION="23.1.7779620"

TARGET_PREFIX="$SCRIPT_DIR/prefix-$ANDROID_TRIPLET$ANDROID_API"

export NDKROOT="$HOME/Android/Sdk/ndk/$ANDROID_NDK_VERSION"

export CC="$NDKROOT/toolchains/llvm/prebuilt/linux-x86_64/bin/$ANDROID_TRIPLET$ANDROID_API-clang"
export CXX="$NDKROOT/toolchains/llvm/prebuilt/linux-x86_64/bin/$ANDROID_TRIPLET$ANDROID_API-clang++"
export AS="$NDKROOT/toolchains/llvm/prebuilt/linux-x86_64/bin/$ANDROID_TRIPLET-as"
export AR="$NDKROOT/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-ar"
export SYSROOT="$NDKROOT/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
export PATH="$NDKROOT/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH"

GMP_SOURCE_DIR="$SCRIPT_DIR/gmp"
GMP_BUILD_DIR="$SCRIPT_DIR/build-gmp-$ANDROID_TRIPLET$ANDROID_API"

MPFR_SOURCE_DIR="$SCRIPT_DIR/mpfr"
MPFR_BUILD_DIR="$SCRIPT_DIR/build-mpfr-$ANDROID_TRIPLET$ANDROID_API"

#
# GNU MP Build
#

if [ ! -f "$TARGET_PREFIX/lib/libgmp.so" ]; then
	if [ -d "$GMP_BUILD_DIR" ]; then
		rm -rf "$GMP_BUILD_DIR"
	fi

	mkdir "$GMP_BUILD_DIR"

	pushd $GMP_BUILD_DIR

	$GMP_SOURCE_DIR/configure --enable-cxx --prefix=$TARGET_PREFIX --host=$ANDROID_TRIPLET

	make -j$(nproc)
	make install

	popd
fi

#
# GNU MPFR Build
#

if [ ! -f "$TARGET_PREFIX/lib/libmpfr.so" ]; then
	if [ -d "$MPFR_BUILD_DIR" ]; then
		rm -rf "$MPFR_BUILD_DIR"
	fi

	mkdir "$MPFR_BUILD_DIR"

	pushd "$MPFR_BUILD_DIR"

	$MPFR_SOURCE_DIR/configure CFLAGS="-L$TARGET_PREFIX/lib" CPPFLAGS="-I$TARGET_PREFIX/include" \
		--prefix=$TARGET_PREFIX --host=$ANDROID_TRIPLET

	make -j$(nproc)
	make install

	popd
fi

#
# Create archive for redist
#

ARCHIVE_OUTPUT=$(pwd)/gnumath-$ANDROID_TRIPLET$ANDROID_API.tar.gz

pushd $TARGET_PREFIX

tar -czvf $ARCHIVE_OUTPUT ./*

popd
