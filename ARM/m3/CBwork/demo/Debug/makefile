################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
EXECUTABLES += \
demo \


# All Target
all: demo secondary-outputs

# Tool invocations
demo: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: Sourcery CodeBench C Linker'
	arm-none-eabi-gcc -Xlinker -Map="demo.map" -T qemu-micro-hosted.ld -mcpu=cortex-m3 -mthumb -o "demo" "@objs.rsp" "@user_objs.rsp" "@libs.rsp"
	@echo 'Finished building target: $@'
	@echo ' '
	$(MAKE) --no-print-directory post-build

# Other Targets
clean:
	-$(RM) $(C_DEPS)$(EXECUTABLES)
	-$(RM) "/home/jon/VistaModels/ARM/m3/CBwork/demo/Debug/demo.o"  demo demo
post-build:
	-arm-none-eabi-size "demo"
	-@echo ' '

secondary-outputs:

.PHONY: all clean dependents
.SECONDARY: post-build

-include ../makefile.targets
