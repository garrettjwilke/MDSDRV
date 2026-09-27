SJASMPLUS := sjasmplus
SALVADOR := salvador
ASM := slop68k
MDSLINK := mdslink

MDSDATA := $(wildcard data/bgm/*.mml) $(wildcard data/bgm/*.mds) $(wildcard data/se/*.mml) $(wildcard data/se/*.mds)

DRIVER_NAME := mdsdrv-rng

.PHONY: all pre-build mdsdrv clean

all: pre-build mdsdrv

clean:
	cd out; rm -f *

mdsdrv: pre-build out/$(DRIVER_NAME).bin

out/$(DRIVER_NAME).bin: src/blob.68k out/mdssub.zx0
	$(ASM) /k /p /o ae- $<,$@

out/mdssub.zx0: out/mdssub.bin
	$(SALVADOR) $< $@

out/mdssub.bin: src/mdssub.z80
	$(SJASMPLUS) $< --raw=$@

pre-build:
	mkdir -p out
