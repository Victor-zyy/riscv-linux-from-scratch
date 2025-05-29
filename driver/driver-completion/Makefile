obj-m += driver-completion.o

KDIR = /home/zyy/repo/linux-5.15.175/

all:
	make -C $(KDIR)  M=$(shell pwd) modules
clean:
	make -C $(KDIR)  M=$(shell pwd) clean
