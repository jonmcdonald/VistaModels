################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_UPPER_SRCS += \
../Vista-Cortex-M3-reset.S 

OBJS += \
./Vista-Cortex-M3-reset.o 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.S
	@echo 'Building file: $<'
	@echo 'Invoking: Sourcery CodeBench Assembler'
	arm-none-eabi-gcc -x assembler-with-cpp -c -g3 -mcpu=cortex-m3 -mthumb -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


