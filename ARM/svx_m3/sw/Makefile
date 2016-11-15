MODEL_BUILDER_HOME=/store/tools/vista4.2.1/papoulis

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CC=arm-none-eabi-gcc
AS=arm-none-eabi-as
LD=arm-none-eabi-ld

RM=rm -f $(1)

all: image.axf

#simpleM4-reset-ram.o : simpleM4-reset-ram.S
#	$(CC) -x assembler-with-cpp -c -g3 -mcpu=cortex-m3 -mthumb simpleM4-reset-ram.S

motor.o : motor.c nvic.h
	$(CC) -I$(MODEL_BUILDER_HOME)/include -O0 -g3 -Wall -c -fmessage-length=0 -fno-common -mcpu=cortex-m3 -mthumb motor.c

image.axf : motor.o stm32100e-eval-ram.ld
	$(CC) -Xlinker -T stm32100e-eval-ram.ld -mcpu=cortex-m3 -mthumb -o image.axf motor.o

rebuild: clean all

clean:
	$(call RM,*.axf)
	$(call RM,*.o)
	$(call RM,*~)



