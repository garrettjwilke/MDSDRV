SJASMPLUS := tools/sjasmplus
SALVADOR := tools/salvador
CLOWNASM := tools/clownassembler_asm68k

.PHONY: all pre-build mdsdrv mdsdata clean submodules tools-build tools-salvador tools-sjasmplus tools-clownassembler

all: pre-build tools-build mdsdrv mdsdata

submodules:
	git submodule update --init --recursive

tools-build: submodules tools-salvador tools-sjasmplus tools-clownassembler

tools-salvador: tools/salvador

tools/salvador: salvador/salvador
	cp $< $@

salvador/salvador:
	$(MAKE) -C salvador

tools-sjasmplus: tools/sjasmplus

tools/sjasmplus: sjasmplus/build/release/sjasmplus
	cp $< $@

sjasmplus/build/release/sjasmplus:
	$(MAKE) -C sjasmplus

tools-clownassembler: tools/clownassembler_asm68k

tools/clownassembler_asm68k: clownassembler/clownassembler_asm68k
	cp $< $@

clownassembler/clownassembler_asm68k:
	$(MAKE) -C clownassembler generators
	$(MAKE) -C clownassembler clownassembler_asm68k

clean:
	cd out; rm -f mdssub.bin mdssub.zx0 mdsdrv.bin
	$(MAKE) -C salvador clean
	$(MAKE) -C sjasmplus clean

mdsdrv: pre-build tools-build out/mdsdrv.bin

out/mdsdrv.bin: src/blob.68k out/mdssub.zx0
	$(CLOWNASM) /k /p /o ae- $<,$@

out/mdssub.zx0: out/mdssub.bin
	$(SALVADOR) $< $@

out/mdssub.bin: src/mdssub.z80
	$(SJASMPLUS) $< --raw=$@

pre-build:
	mkdir -p out
