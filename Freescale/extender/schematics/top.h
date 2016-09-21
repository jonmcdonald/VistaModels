#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/FPGA_I2C_custom_model.h"
#include "iMX6_SoC.h"
#include "../models/I2C_Switch_model.h"
#include "../models/CustomPeripheral_model.h"
$includes_end;
 
$module_begin("top");
SC_MODULE(top) {
public:
  typedef top SC_CURRENT_USER_MODULE;
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("i2c_0x03"),
i2c_0x03(0)
$end
$init("iMX6_inst"),
iMX6_inst(0)
$end
$init("I2C_Switch_inst"),
I2C_Switch_inst(0)
$end
$init("i2c_0x04"),
i2c_0x04(0)
$end
$init("i2c_0x05"),
i2c_0x05(0)
$end
$init("led_switch"),
led_switch(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("i2c_0x03");
i2c_0x03 = new FPGA_I2C_custom_pvt("i2c_0x03");
$end;
$create_component("iMX6_inst");
iMX6_inst = new iMX6_SoC("iMX6_inst");
$end;
$create_component("I2C_Switch_inst");
I2C_Switch_inst = new I2C_Switch_pvt("I2C_Switch_inst");
$end;
$create_component("i2c_0x04");
i2c_0x04 = new FPGA_I2C_custom_pvt("i2c_0x04");
$end;
$create_component("i2c_0x05");
i2c_0x05 = new FPGA_I2C_custom_pvt("i2c_0x05");
$end;
$create_component("led_switch");
led_switch = new CustomPeripheral_pvt("led_switch");
$end;
$bind("I2C_Switch_inst->device_0x03","i2c_0x03->slave");
vista_bind(I2C_Switch_inst->device_0x03, i2c_0x03->slave);
$end;
$bind("iMX6_inst->I2C1_Bus","I2C_Switch_inst->slave");
vista_bind(iMX6_inst->I2C1_Bus, I2C_Switch_inst->slave);
$end;
$bind("I2C_Switch_inst->device_0x04","i2c_0x04->slave");
vista_bind(I2C_Switch_inst->device_0x04, i2c_0x04->slave);
$end;
$bind("led_switch->out","iMX6_inst->GPIO0_IN1");
vista_bind(led_switch->out, iMX6_inst->GPIO0_IN1);
$end;
$bind("iMX6_inst->GPIO0_OUT0","led_switch->in");
vista_bind(iMX6_inst->GPIO0_OUT0, led_switch->in);
$end;
$bind("I2C_Switch_inst->device_0x05","i2c_0x05->slave");
vista_bind(I2C_Switch_inst->device_0x05, i2c_0x05->slave);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "schematics";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("i2c_0x03");
delete i2c_0x03; i2c_0x03 = 0;
$end;
$destruct_component("iMX6_inst");
delete iMX6_inst; iMX6_inst = 0;
$end;
$destruct_component("I2C_Switch_inst");
delete I2C_Switch_inst; I2C_Switch_inst = 0;
$end;
$destruct_component("i2c_0x04");
delete i2c_0x04; i2c_0x04 = 0;
$end;
$destruct_component("i2c_0x05");
delete i2c_0x05; i2c_0x05 = 0;
$end;
$destruct_component("led_switch");
delete led_switch; led_switch = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("i2c_0x03");
FPGA_I2C_custom_pvt *i2c_0x03;
$end;
$component("iMX6_inst");
iMX6_SoC *iMX6_inst;
$end;
$component("I2C_Switch_inst");
I2C_Switch_pvt *I2C_Switch_inst;
$end;
$component("i2c_0x04");
FPGA_I2C_custom_pvt *i2c_0x04;
$end;
$component("i2c_0x05");
FPGA_I2C_custom_pvt *i2c_0x05;
$end;
$component("led_switch");
CustomPeripheral_pvt *led_switch;
$end;
  $fields_end;
  $vlnv_decl_begin;
public:
const char* m_library;
const char* m_vendor;
const char* m_version;
  $vlnv_decl_end;
};
$module_end;
