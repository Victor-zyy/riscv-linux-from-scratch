obj-m += hello-real.o

#You can update your Beaglebone path here.
KDIR = /home/zyy/repo/linux-5.15.175/

module:
	make -C $(KDIR)  M=$(shell pwd) modules
app:
	riscv64-linux-gnu-gcc -static -o test_app test_app.c
clean:
	make -C $(KDIR)  M=$(shell pwd) clean
	rm -rf test_app
