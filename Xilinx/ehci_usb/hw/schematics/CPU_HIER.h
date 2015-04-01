#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "zynq_models/CortexA9MP_model.h"
$includes_end;

$module_begin("CPU_HIER");
SC_MODULE(CPU_HIER) {
public:
  CPU_HIER(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("PL10_irq"),
PL10_irq("PL10_irq")
$end
$init("smc_irq"),
smc_irq("smc_irq")
$end
$init("PL7_irq"),
PL7_irq("PL7_irq")
$end
$init("i2c0_irq"),
i2c0_irq("i2c0_irq")
$end
$init("PL4_irq"),
PL4_irq("PL4_irq")
$end
$init("PL1_irq"),
PL1_irq("PL1_irq")
$end
$init("Ethernet1_irq"),
Ethernet1_irq("Ethernet1_irq")
$end
$init("PL15_irq"),
PL15_irq("PL15_irq")
$end
$init("ttc1_irq1"),
ttc1_irq1("ttc1_irq1")
$end
$init("ttc1_irq2"),
ttc1_irq2("ttc1_irq2")
$end
$init("ttc1_irq3"),
ttc1_irq3("ttc1_irq3")
$end
$init("uart1_irq"),
uart1_irq("uart1_irq")
$end
$init("ACP_slave"),
ACP_slave("ACP_slave")
$end
$init("sdhc1_irq"),
sdhc1_irq("sdhc1_irq")
$end
$init("PL12_irq"),
PL12_irq("PL12_irq")
$end
$init("dmac_irq0"),
dmac_irq0("dmac_irq0")
$end
$init("dmac_irq1"),
dmac_irq1("dmac_irq1")
$end
$init("dmac_irq2"),
dmac_irq2("dmac_irq2")
$end
$init("dmac_irq3"),
dmac_irq3("dmac_irq3")
$end
$init("dmac_irq4"),
dmac_irq4("dmac_irq4")
$end
$init("n_reset_1"),
n_reset_1("n_reset_1")
$end
$init("dmac_irq5"),
dmac_irq5("dmac_irq5")
$end
$init("dmac_abort"),
dmac_abort("dmac_abort")
$end
$init("dmac_irq6"),
dmac_irq6("dmac_irq6")
$end
$init("dmac_irq7"),
dmac_irq7("dmac_irq7")
$end
$init("PL8_irq"),
PL8_irq("PL8_irq")
$end
$init("PL5_irq"),
PL5_irq("PL5_irq")
$end
$init("usb0_irq"),
usb0_irq("usb0_irq")
$end
$init("PL2_irq"),
PL2_irq("PL2_irq")
$end
$init("ocm_irq"),
ocm_irq("ocm_irq")
$end
$init("spi1_irq"),
spi1_irq("spi1_irq")
$end
$init("PL14_irq"),
PL14_irq("PL14_irq")
$end
$init("ttc0_irq1"),
ttc0_irq1("ttc0_irq1")
$end
$init("ttc0_irq2"),
ttc0_irq2("ttc0_irq2")
$end
$init("ttc0_irq3"),
ttc0_irq3("ttc0_irq3")
$end
$init("qspi0_irq"),
qspi0_irq("qspi0_irq")
$end
$init("PL11_irq"),
PL11_irq("PL11_irq")
$end
$init("i2c1_irq"),
i2c1_irq("i2c1_irq")
$end
$init("gpio_irq"),
gpio_irq("gpio_irq")
$end
$init("PL9_irq"),
PL9_irq("PL9_irq")
$end
$init("PL6_irq"),
PL6_irq("PL6_irq")
$end
$init("Ethernet0_irq"),
Ethernet0_irq("Ethernet0_irq")
$end
$init("l2cache_irq"),
l2cache_irq("l2cache_irq")
$end
$init("PL3_irq"),
PL3_irq("PL3_irq")
$end
$init("PL0_irq"),
PL0_irq("PL0_irq")
$end
$init("spi0_irq"),
spi0_irq("spi0_irq")
$end
$init("PL13_irq"),
PL13_irq("PL13_irq")
$end
$init("uart0_irq"),
uart0_irq("uart0_irq")
$end
$init("sdhc0_irq"),
sdhc0_irq("sdhc0_irq")
$end
$init("usb1_irq"),
usb1_irq("usb1_irq")
$end
$init("master0"),
master0("master0")
$end
$init("master1"),
master1("master1")
$end
$init("CPU_INST0"),
CPU_INST0(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("CPU_INST0");
CPU_INST0 = new CortexA9MP_pvt("CPU_INST0");
$end;
$bind("PL9_irq","CPU_INST0->irq_53");
vista_bind(PL9_irq, CPU_INST0->irq_53);
$end;
$bind("PL7_irq","CPU_INST0->irq_36");
vista_bind(PL7_irq, CPU_INST0->irq_36);
$end;
$bind("PL4_irq","CPU_INST0->irq_33");
vista_bind(PL4_irq, CPU_INST0->irq_33);
$end;
$bind("PL1_irq","CPU_INST0->irq_30");
vista_bind(PL1_irq, CPU_INST0->irq_30);
$end;
$bind("PL15_irq","CPU_INST0->irq_59");
vista_bind(PL15_irq, CPU_INST0->irq_59);
$end;
$bind("gpio_irq","CPU_INST0->irq_20");
vista_bind(gpio_irq, CPU_INST0->irq_20);
$end;
$bind("n_reset_1","CPU_INST0->n_reset_1");
vista_bind(n_reset_1, CPU_INST0->n_reset_1);
$end;
$bind("ttc1_irq2","CPU_INST0->irq_38");
vista_bind(ttc1_irq2, CPU_INST0->irq_38);
$end;
$bind("uart0_irq","CPU_INST0->irq_27");
vista_bind(uart0_irq, CPU_INST0->irq_27);
$end;
$bind("ttc0_irq2","CPU_INST0->irq_11");
vista_bind(ttc0_irq2, CPU_INST0->irq_11);
$end;
$bind("CPU_INST0->master0","master0");
vista_bind(CPU_INST0->master0, master0);
$end;
$bind("ocm_irq","CPU_INST0->irq_3");
vista_bind(ocm_irq, CPU_INST0->irq_3);
$end;
$bind("dmac_irq0","CPU_INST0->irq_14");
vista_bind(dmac_irq0, CPU_INST0->irq_14);
$end;
$bind("PL12_irq","CPU_INST0->irq_56");
vista_bind(PL12_irq, CPU_INST0->irq_56);
$end;
$bind("spi1_irq","CPU_INST0->irq_49");
vista_bind(spi1_irq, CPU_INST0->irq_49);
$end;
$bind("sdhc0_irq","CPU_INST0->irq_24");
vista_bind(sdhc0_irq, CPU_INST0->irq_24);
$end;
$bind("dmac_irq4","CPU_INST0->irq_40");
vista_bind(dmac_irq4, CPU_INST0->irq_40);
$end;
$bind("spi0_irq","CPU_INST0->irq_26");
vista_bind(spi0_irq, CPU_INST0->irq_26);
$end;
$bind("CPU_INST0->master1","master1");
vista_bind(CPU_INST0->master1, master1);
$end;
$bind("dmac_irq3","CPU_INST0->irq_17");
vista_bind(dmac_irq3, CPU_INST0->irq_17);
$end;
$bind("PL5_irq","CPU_INST0->irq_34");
vista_bind(PL5_irq, CPU_INST0->irq_34);
$end;
$bind("dmac_irq6","CPU_INST0->irq_42");
vista_bind(dmac_irq6, CPU_INST0->irq_42);
$end;
$bind("PL2_irq","CPU_INST0->irq_31");
vista_bind(PL2_irq, CPU_INST0->irq_31);
$end;
$bind("i2c1_irq","CPU_INST0->irq_48");
vista_bind(i2c1_irq, CPU_INST0->irq_48);
$end;
$bind("PL14_irq","CPU_INST0->irq_58");
vista_bind(PL14_irq, CPU_INST0->irq_58);
$end;
$bind("i2c0_irq","CPU_INST0->irq_25");
vista_bind(i2c0_irq, CPU_INST0->irq_25);
$end;
$bind("ttc1_irq3","CPU_INST0->irq_39");
vista_bind(ttc1_irq3, CPU_INST0->irq_39);
$end;
$bind("ttc0_irq3","CPU_INST0->irq_12");
vista_bind(ttc0_irq3, CPU_INST0->irq_12);
$end;
$bind("dmac_irq1","CPU_INST0->irq_15");
vista_bind(dmac_irq1, CPU_INST0->irq_15);
$end;
$bind("PL11_irq","CPU_INST0->irq_55");
vista_bind(PL11_irq, CPU_INST0->irq_55);
$end;
$bind("PL0_irq","CPU_INST0->irq_29");
vista_bind(PL0_irq, CPU_INST0->irq_29);
$end;
$bind("ACP_slave","CPU_INST0->acp");
vista_bind(ACP_slave, CPU_INST0->acp);
$end;
$bind("PL8_irq","CPU_INST0->irq_52");
vista_bind(PL8_irq, CPU_INST0->irq_52);
$end;
$bind("qspi0_irq","CPU_INST0->irq_19");
vista_bind(qspi0_irq, CPU_INST0->irq_19);
$end;
$bind("PL6_irq","CPU_INST0->irq_35");
vista_bind(PL6_irq, CPU_INST0->irq_35);
$end;
$bind("PL3_irq","CPU_INST0->irq_32");
vista_bind(PL3_irq, CPU_INST0->irq_32);
$end;
$bind("smc_irq","CPU_INST0->irq_18");
vista_bind(smc_irq, CPU_INST0->irq_18);
$end;
$bind("ttc1_irq1","CPU_INST0->irq_37");
vista_bind(ttc1_irq1, CPU_INST0->irq_37);
$end;
$bind("ttc0_irq1","CPU_INST0->irq_10");
vista_bind(ttc0_irq1, CPU_INST0->irq_10);
$end;
$bind("usb1_irq","CPU_INST0->irq_44");
vista_bind(usb1_irq, CPU_INST0->irq_44);
$end;
$bind("dmac_abort","CPU_INST0->irq_13");
vista_bind(dmac_abort, CPU_INST0->irq_13);
$end;
$bind("dmac_irq7","CPU_INST0->irq_43");
vista_bind(dmac_irq7, CPU_INST0->irq_43);
$end;
$bind("sdhc1_irq","CPU_INST0->irq_47");
vista_bind(sdhc1_irq, CPU_INST0->irq_47);
$end;
$bind("usb0_irq","CPU_INST0->irq_21");
vista_bind(usb0_irq, CPU_INST0->irq_21);
$end;
$bind("PL13_irq","CPU_INST0->irq_57");
vista_bind(PL13_irq, CPU_INST0->irq_57);
$end;
$bind("uart1_irq","CPU_INST0->irq_50");
vista_bind(uart1_irq, CPU_INST0->irq_50);
$end;
$bind("Ethernet1_irq","CPU_INST0->irq_45");
vista_bind(Ethernet1_irq, CPU_INST0->irq_45);
$end;
$bind("PL10_irq","CPU_INST0->irq_54");
vista_bind(PL10_irq, CPU_INST0->irq_54);
$end;
$bind("l2cache_irq","CPU_INST0->irq_2");
vista_bind(l2cache_irq, CPU_INST0->irq_2);
$end;
$bind("dmac_irq2","CPU_INST0->irq_16");
vista_bind(dmac_irq2, CPU_INST0->irq_16);
$end;
$bind("Ethernet0_irq","CPU_INST0->irq_22");
vista_bind(Ethernet0_irq, CPU_INST0->irq_22);
$end;
$bind("dmac_irq5","CPU_INST0->irq_41");
vista_bind(dmac_irq5, CPU_INST0->irq_41);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "schematics";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~CPU_HIER() {
    $destructor_begin;
$destruct_component("CPU_INST0");
delete CPU_INST0; CPU_INST0 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$socket("PL10_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL10_irq;
$end;
$socket("smc_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > smc_irq;
$end;
$socket("PL7_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL7_irq;
$end;
$socket("i2c0_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > i2c0_irq;
$end;
$socket("PL4_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL4_irq;
$end;
$socket("PL1_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL1_irq;
$end;
$socket("Ethernet1_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > Ethernet1_irq;
$end;
$socket("PL15_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL15_irq;
$end;
$socket("ttc1_irq1");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > ttc1_irq1;
$end;
$socket("ttc1_irq2");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > ttc1_irq2;
$end;
$socket("ttc1_irq3");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > ttc1_irq3;
$end;
$socket("uart1_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > uart1_irq;
$end;
$socket("ACP_slave");
tlm::tlm_target_socket< 64U,axi_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > ACP_slave;
$end;
$socket("sdhc1_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > sdhc1_irq;
$end;
$socket("PL12_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL12_irq;
$end;
$socket("dmac_irq0");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > dmac_irq0;
$end;
$socket("dmac_irq1");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > dmac_irq1;
$end;
$socket("dmac_irq2");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > dmac_irq2;
$end;
$socket("dmac_irq3");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > dmac_irq3;
$end;
$socket("dmac_irq4");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > dmac_irq4;
$end;
$socket("n_reset_1");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > n_reset_1;
$end;
$socket("dmac_irq5");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > dmac_irq5;
$end;
$socket("dmac_abort");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > dmac_abort;
$end;
$socket("dmac_irq6");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > dmac_irq6;
$end;
$socket("dmac_irq7");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > dmac_irq7;
$end;
$socket("PL8_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL8_irq;
$end;
$socket("PL5_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL5_irq;
$end;
$socket("usb0_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > usb0_irq;
$end;
$socket("PL2_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL2_irq;
$end;
$socket("ocm_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > ocm_irq;
$end;
$socket("spi1_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > spi1_irq;
$end;
$socket("PL14_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL14_irq;
$end;
$socket("ttc0_irq1");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > ttc0_irq1;
$end;
$socket("ttc0_irq2");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > ttc0_irq2;
$end;
$socket("ttc0_irq3");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > ttc0_irq3;
$end;
$socket("qspi0_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > qspi0_irq;
$end;
$socket("PL11_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL11_irq;
$end;
$socket("i2c1_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > i2c1_irq;
$end;
$socket("gpio_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > gpio_irq;
$end;
$socket("PL9_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL9_irq;
$end;
$socket("PL6_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL6_irq;
$end;
$socket("Ethernet0_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > Ethernet0_irq;
$end;
$socket("l2cache_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > l2cache_irq;
$end;
$socket("PL3_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL3_irq;
$end;
$socket("PL0_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL0_irq;
$end;
$socket("spi0_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > spi0_irq;
$end;
$socket("PL13_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL13_irq;
$end;
$socket("uart0_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > uart0_irq;
$end;
$socket("sdhc0_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > sdhc0_irq;
$end;
$socket("usb1_irq");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > usb1_irq;
$end;
$socket("master0");
tlm::tlm_initiator_socket< 64U,axi_protocol_types,1,sc_core::SC_ONE_OR_MORE_BOUND > master0;
$end;
$socket("master1");
tlm::tlm_initiator_socket< 64U,axi_protocol_types,1,sc_core::SC_ONE_OR_MORE_BOUND > master1;
$end;
$component("CPU_INST0");
CortexA9MP_pvt *CPU_INST0;
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