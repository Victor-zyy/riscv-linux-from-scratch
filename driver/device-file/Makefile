obj-m += hello-devd.o

#You can update your Beaglebone path here.
KDIR = /home/zyy/repo/linux-5.15.175/

all:
	make -C $(KDIR)  M=$(shell pwd) modules
clean:
	make -C $(KDIR)  M=$(shell pwd) clean
