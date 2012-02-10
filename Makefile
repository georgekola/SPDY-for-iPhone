BUILD:=$(shell pwd)/build
PKG_CONFIG_PATH=$(BUILD)/lib/pkgconfig

all: spdylay


build/lib/libcrypto.a: OpenSSL-for-iPhone/build-libssl.sh
	cd OpenSSL-for-iPhone && INSTALL_DIR=$(BUILD) ./build-libssl.sh

openssl: build/lib/libcrypto.a


spdylay/configure: spdylay/configure.ac zlib openssl
	cd spdylay && autoreconf -i && automake && autoconf

spdylay/Makefile: spdylay/configure
	cd spdylay && ../ios-configure -p "$(BUILD)" iphone

spdylay: spdylay/Makefile
	cd spdylay && make install

spdylay: build/lib/libspdylay.a


build/lib/libz.a: zlib/build-zlib.sh
	cd zlib && ROOTDIR=$(BUILD) ./build-zlib.sh

zlib: build/lib/libz.a


.PHONY: all spdylay zlib openssl
