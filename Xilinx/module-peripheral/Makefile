obj-m += peripheral_driver.o 

M = `pwd`

mybuild:
	make -C $(LINUX) M=$M

clean:
	rm built-in.o modules.order Module.symvers peripheral_driver.mod.o 
	rm peripheral_driver.ko peripheral_driver.mod.c peripheral_driver.o
