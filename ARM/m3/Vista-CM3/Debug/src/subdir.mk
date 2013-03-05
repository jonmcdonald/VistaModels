################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/demo.c 

OBJS += \
./src/demo.o 

C_DEPS += \
./src/demo.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Sourcery CodeBench C Compiler'
	arm-none-eabi-gcc -I"/home/jon/VistaModels/ARM/m3/CBwork/Vista-CM3/CMSIS" -O0 -g3 -Wall -c -fmessage-length=0 -fno-common -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -mcpu=cortex-m3 -mthumb -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


