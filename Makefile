
build:
	cargo bootimage

run:
	cd target/x86_64-opos/debug/ && qemu-system-x86_64 -drive format=raw,file=bootimage-opos.bin
