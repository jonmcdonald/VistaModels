################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../Rijndael.cpp \
../Test.cpp 

OBJS += \
./Rijndael.o \
./Test.o 

CPP_DEPS += \
./Rijndael.d \
./Test.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Sourcery CodeBench C++ Compiler'
	arm-none-eabi-g++ -O0 -g3 -Wall -c -fmessage-length=0 -fpermissive -fno-common -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -mcpu=cortex-m3 -mthumb -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


