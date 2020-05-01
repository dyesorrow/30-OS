TOOLPATH = ../../tool/

# MAKE     = $(TOOLPATH)make.exe -r
MAKE     = make -r
EDIMG    = $(TOOLPATH)edimg.exe
NASK     = $(TOOLPATH)nask.exe


ipl.bin: ipl.nas
	$(NASK) ipl.nas ipl.bin ipl.lst

helloos.img: ipl.bin
	$(EDIMG) imgin:$(TOOLPATH)fdimg0at.tek wbinimg src:ipl.bin len:512 from:0 to:0  imgout:helloos.img
	
run: helloos.img
	cp helloos.img $(TOOLPATH)qemu/fdimage0.bin
	make -C $(TOOLPATH)qemu