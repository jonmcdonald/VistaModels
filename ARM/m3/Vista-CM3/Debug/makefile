################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/subdir.mk
-include CMSIS/subdir.mk
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
Vista-CM3 \


# All Target
all: Vista-CM3 secondary-outputs

# Tool invocations
Vista-CM3: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: Sourcery CodeBench C Linker'
	arm-none-eabi-gcc -Xlinker -Map="Vista-CM3.map" -T /home/jon/VistaModels/ARM/m3/CBwork/Vista-CM3/Vista-Cortex-M3-rom-hosted.ld -mcpu=cortex-m3 -mthumb -o "Vista-CM3" "@objs.rsp" "@user_objs.rsp" "@libs.rsp"
	@echo 'Finished building target: $@'
	@echo ' '
	$(MAKE) --no-print-directory post-build

# Other Targets
clean:
	-$(RM) $(C_DEPS)$(EXECUTABLES)
	-$(RM) "/home/jon/VistaModels/ARM/m3/CBwork/Vista-CM3/Debug/src/demo.o" "/home/jon/VistaModels/ARM/m3/CBwork/Vista-CM3/Debug/Vista-Cortex-M3-reset.o" "/home/jon/VistaModels/ARM/m3/CBwork/Vista-CM3/Debug/CMSIS/system_VistaCM3.o"  Vista-CM3 Vista-CM3
post-build:
	-arm-none-eabi-size "Vista-CM3"
	-@echo ' '

secondary-outputs:

.PHONY: all clean dependents
.SECONDARY: post-build

-include ../makefile.targets
