TOOLPATH = ../../tool/

# MAKE     = $(TOOLPATH)make.exe -r
MAKE     = make -r
EDIMG    = $(TOOLPATH)edimg.exe
NASK     = $(TOOLPATH)nask.exe


ipl.bin: ipl.nas
	$(NASK) ipl.nas ipl.bin ipl.lst

haribote.sys: haribote.nas
	$(NASK) haribote.nas haribote.sys haribote.lst

helloos.img: ipl.bin haribote.sys
	$(EDIMG) imgin:$(TOOLPATH)fdimg0at.tek \
	wbinimg src:ipl.bin len:512 from:0 to:0  \
	copy from:haribote.sys to:@: \
	imgout:helloos.img
	
run: helloos.img
	cp helloos.img $(TOOLPATH)qemu/fdimage0.bin
	make -C $(TOOLPATH)qemu

clean:
	-rm -rf *.sys *.img *.lst *.bin