
all: fetch tools sysroot kernel modules busybox dropbear zlib ssl openssh qt cluster sdcard axf

linux: fetch tools sysroot kernel modules busybox dropbear zlib ssl openssh sdcard axf

.PHONY: fetch tools sysroot kernel modules busybox dropbear zlib ssl openssh qt cluster sdcard axf clean

fetch:
	./script/fetch.sh

tools: fetch
	./script/build_tools.sh

sysroot: fetch
	./script/build_sysroot.sh

kernel: fetch
	./script/build_kernel.sh

modules: fetch
	./script/build_modules.sh

busybox: fetch
	./script/build_busybox.sh

dropbear: fetch
	./script/build_dropbear.sh

zlib: fetch
	./script/build_zlib.sh

ssl: fetch
	./script/build_ssl.sh

openssh: fetch
	./script/build_openssh.sh

qt: fetch
	./script/build_qt.sh

cluster:
	./script/build_cluster.sh

sdcard:
	./script/build_sdcard.sh

axf:
	./script/build_axf.sh

clean:
	./script/clean.sh

