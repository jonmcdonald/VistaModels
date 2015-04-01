#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "models_catalogue.h"
#include "zynq_models/dma_irq_splitter_model.h"
#include "zynq_models/Zynq_GEM_model.h"
#include "zynq_models/Zynq_GPIO_model.h"
#include "zynq_schematics/AXI_HP_Controllers.h"
#include "zynq_models/zynq_slcr_model.h"
#include "zynq_models/AXI2AHB32_model.h"
#include "zynq_models/apb_bus_model.h"
#include "zynq_models/Zynq_DDRC_model.h"
#include "zynq_models/AHB2AXI32_model.h"
#include "zynq_models/Cadence_TTC_model.h"
#include "zynq_models/Console_model.h"
#include "zynq_models/Zynq_QSPI_model.h"
#include "zynq_models/APB32toAPB16_model.h"
#include "zynq_models/ahb_bus_CI_model.h"
#include "zynq_models/Slave_Interconnect_model.h"
#include "zynq_models/AXI_bus_SI_model.h"
#include "zynq_models/Cadence_UART_model.h"
#include "zynq_models/Zynq_I2C_model.h"
#include "zynq_models/AXI32toAXI64_model.h"
#include "../models/APB_AXI_model.h"
#include "zynq_models/Zynq_DDRC_sf_model.h"
#include "zynq_models/Zynq_AXI_GP_model.h"
#include "zynq_models/axi_bus_model.h"
#include "zynq_models/Zynq_trustzone_model.h"
#include "zynq_models/Zynq_OCM_model.h"
#include "zynq_models/Zynq_OCM_sf_model.h"
#include "zynq_models/MEM_model.h"
#include "zynq_models/AXI2APB32_model.h"
#include "zynq_models/Zynq_SPI_model.h"
#include "../models/USB_EHCI_model.h"
#include "zynq_models/Memory_Interconnect_model.h"
#include "zynq_models/PL310_model.h"
#include "zynq_models/Zynq_SDHC_model.h"
#include "../models/APB_BUS_USB_model.h"
#include "CPU_HIER.h"
$includes_end;

$module_begin("Zynq_SoC");
SC_MODULE(Zynq_SoC) {
public:
  Zynq_SoC(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("S_AXI_ACP"),
S_AXI_ACP("S_AXI_ACP")
$end
$init("PL7_IRQ"),
PL7_IRQ("PL7_IRQ")
$end
$init("PL4_IRQ"),
PL4_IRQ("PL4_IRQ")
$end
$init("PL14_IRQ"),
PL14_IRQ("PL14_IRQ")
$end
$init("PL1_IRQ"),
PL1_IRQ("PL1_IRQ")
$end
$init("PL11_IRQ"),
PL11_IRQ("PL11_IRQ")
$end
$init("PL8_IRQ"),
PL8_IRQ("PL8_IRQ")
$end
$init("PL5_IRQ"),
PL5_IRQ("PL5_IRQ")
$end
$init("PL2_IRQ"),
PL2_IRQ("PL2_IRQ")
$end
$init("PL13_IRQ"),
PL13_IRQ("PL13_IRQ")
$end
$init("PL10_IRQ"),
PL10_IRQ("PL10_IRQ")
$end
$init("S_AXI_GP0"),
S_AXI_GP0("S_AXI_GP0")
$end
$init("S_AXI_GP1"),
S_AXI_GP1("S_AXI_GP1")
$end
$init("S_AXI_HP0"),
S_AXI_HP0("S_AXI_HP0")
$end
$init("S_AXI_HP1"),
S_AXI_HP1("S_AXI_HP1")
$end
$init("S_AXI_HP2"),
S_AXI_HP2("S_AXI_HP2")
$end
$init("S_AXI_HP3"),
S_AXI_HP3("S_AXI_HP3")
$end
$init("PL15_IRQ"),
PL15_IRQ("PL15_IRQ")
$end
$init("PL9_IRQ"),
PL9_IRQ("PL9_IRQ")
$end
$init("PL6_IRQ"),
PL6_IRQ("PL6_IRQ")
$end
$init("PL3_IRQ"),
PL3_IRQ("PL3_IRQ")
$end
$init("PL0_IRQ"),
PL0_IRQ("PL0_IRQ")
$end
$init("PL12_IRQ"),
PL12_IRQ("PL12_IRQ")
$end
$init("GPIN1"),
GPIN1("GPIN1")
$end
$init("GPIN3"),
GPIN3("GPIN3")
$end
$init("GPIN0"),
GPIN0("GPIN0")
$end
$init("GPIN2"),
GPIN2("GPIN2")
$end
$init("M_AXI_GP0"),
M_AXI_GP0("M_AXI_GP0")
$end
$init("M_AXI_GP1"),
M_AXI_GP1("M_AXI_GP1")
$end
$init("GPOUT1"),
GPOUT1("GPOUT1")
$end
$init("GPOUT2"),
GPOUT2("GPOUT2")
$end
$init("GPOUT0"),
GPOUT0("GPOUT0")
$end
$init("GPOUT3"),
GPOUT3("GPOUT3")
$end
$init("HP_memory_interconnect"),
HP_memory_interconnect(0)
$end
$init("axi_inst0"),
axi_inst0(0)
$end
$init("i2c_inst0"),
i2c_inst0(0)
$end
$init("slcr_inst"),
slcr_inst(0)
$end
$init("i2c_inst1"),
i2c_inst1(0)
$end
$init("dmac0_irq_split"),
dmac0_irq_split(0)
$end
$init("smc"),
smc(0)
$end
$init("qspi_inst0"),
qspi_inst0(0)
$end
$init("axi_bus_SI_inst00"),
axi_bus_SI_inst00(0)
$end
$init("ttc1_inst"),
ttc1_inst(0)
$end
$init("L2Cache"),
L2Cache(0)
$end
$init("PS_apb"),
PS_apb(0)
$end
$init("AXI_HP_controllers"),
AXI_HP_controllers(0)
$end
$init("console_inst0"),
console_inst0(0)
$end
$init("console_inst1"),
console_inst1(0)
$end
$init("axi32toaxi64_bridge_inst00"),
axi32toaxi64_bridge_inst00(0)
$end
$init("ocm_inst0"),
ocm_inst0(0)
$end
$init("uart_inst0"),
uart_inst0(0)
$end
$init("M_AXI_GP_inst0"),
M_AXI_GP_inst0(0)
$end
$init("uart_inst1"),
uart_inst1(0)
$end
$init("SlaveInterconnect0"),
SlaveInterconnect0(0)
$end
$init("M_AXI_GP_inst1"),
M_AXI_GP_inst1(0)
$end
$init("Eth_inst0"),
Eth_inst0(0)
$end
$init("Eth_inst1"),
Eth_inst1(0)
$end
$init("S_AXI_GP_inst0"),
S_AXI_GP_inst0(0)
$end
$init("S_AXI_GP_inst1"),
S_AXI_GP_inst1(0)
$end
$init("sdhc_inst0"),
sdhc_inst0(0)
$end
$init("sdhc_inst1"),
sdhc_inst1(0)
$end
$init("apb_bus_inst01"),
apb_bus_inst01(0)
$end
$init("ttc0_inst"),
ttc0_inst(0)
$end
$init("gpio_inst0"),
gpio_inst0(0)
$end
$init("PS_inst"),
PS_inst(0)
$end
$init("ddrc_inst0"),
ddrc_inst0(0)
$end
$init("cpu_inst0"),
cpu_inst0(0)
$end
$init("ahb_bus_CI_inst00"),
ahb_bus_CI_inst00(0)
$end
$init("dmac_inst0"),
dmac_inst0(0)
$end
$init("APB32toAPB16_bridge_inst00"),
APB32toAPB16_bridge_inst00(0)
$end
$init("APB32toAPB16_bridge_inst01"),
APB32toAPB16_bridge_inst01(0)
$end
$init("axi2ahb_bridge_inst00"),
axi2ahb_bridge_inst00(0)
$end
$init("axi2ahb_bridge_inst01"),
axi2ahb_bridge_inst01(0)
$end
$init("spi_inst0"),
spi_inst0(0)
$end
$init("spi_inst1"),
spi_inst1(0)
$end
$init("ahb2axi_bridge_inst00"),
ahb2axi_bridge_inst00(0)
$end
$init("trustzone_inst"),
trustzone_inst(0)
$end
$init("axi2apb_bus_bridge00"),
axi2apb_bus_bridge00(0)
$end
$init("apb_bus_inst00"),
apb_bus_inst00(0)
$end
$init("ddrc_sf0"),
ddrc_sf0(0)
$end
$init("ocm_sf0"),
ocm_sf0(0)
$end
$init("apb_axi_usb1"),
apb_axi_usb1(0)
$end
$init("apb_axi_usb0"),
apb_axi_usb0(0)
$end
$init("USB1"),
USB1(0)
$end
$init("USB0"),
USB0(0)
$end
$init("apb_bus_usb"),
apb_bus_usb(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("HP_memory_interconnect");
HP_memory_interconnect = new Memory_Interconnect_pvt("HP_memory_interconnect");
$end;
$create_component("axi_inst0");
axi_inst0 = new axi_bus_pvt("axi_inst0");
$end;
$create_component("i2c_inst0");
i2c_inst0 = new Zynq_I2C_pvt("i2c_inst0");
$end;
$create_component("slcr_inst");
slcr_inst = new zynq_slcr_pvt("slcr_inst");
$end;
$create_component("i2c_inst1");
i2c_inst1 = new Zynq_I2C_pvt("i2c_inst1");
$end;
$create_component("dmac0_irq_split");
dmac0_irq_split = new dma_irq_splitter_pvt("dmac0_irq_split");
$end;
$create_component("smc");
smc = new SMC_PL350_pvt("smc");
$end;
$create_component("qspi_inst0");
qspi_inst0 = new Zynq_QSPI_pvt("qspi_inst0");
$end;
$create_component("axi_bus_SI_inst00");
axi_bus_SI_inst00 = new AXI_bus_SI_pvt("axi_bus_SI_inst00");
$end;
$create_component("ttc1_inst");
ttc1_inst = new Cadence_TTC_pvt("ttc1_inst");
$end;
$create_component("L2Cache");
L2Cache = new PL310_pvt("L2Cache");
$end;
$create_component("PS_apb");
PS_apb = new AXI2APB32_pvt("PS_apb");
$end;
$create_component("AXI_HP_controllers");
AXI_HP_controllers = new AXI_HP_Controllers("AXI_HP_controllers");
$end;
$create_component("console_inst0");
console_inst0 = new Console_pvt("console_inst0");
$end;
$create_component("console_inst1");
console_inst1 = new Console_pvt("console_inst1");
$end;
$create_component("axi32toaxi64_bridge_inst00");
axi32toaxi64_bridge_inst00 = new AXI32toAXI64_pvt("axi32toaxi64_bridge_inst00");
$end;
$create_component("ocm_inst0");
ocm_inst0 = new Zynq_OCM_pvt("ocm_inst0");
$end;
$create_component("uart_inst0");
uart_inst0 = new Cadence_UART_pvt("uart_inst0");
$end;
$create_component("M_AXI_GP_inst0");
M_AXI_GP_inst0 = new Zynq_AXI_GP_pvt("M_AXI_GP_inst0");
$end;
$create_component("uart_inst1");
uart_inst1 = new Cadence_UART_pvt("uart_inst1");
$end;
$create_component("SlaveInterconnect0");
SlaveInterconnect0 = new Slave_Interconnect_pvt("SlaveInterconnect0");
$end;
$create_component("M_AXI_GP_inst1");
M_AXI_GP_inst1 = new Zynq_AXI_GP_pvt("M_AXI_GP_inst1");
$end;
$create_component("Eth_inst0");
Eth_inst0 = new Zynq_GEM_pvt("Eth_inst0");
$end;
$create_component("Eth_inst1");
Eth_inst1 = new Zynq_GEM_pvt("Eth_inst1");
$end;
$create_component("S_AXI_GP_inst0");
S_AXI_GP_inst0 = new Zynq_AXI_GP_pvt("S_AXI_GP_inst0");
$end;
$create_component("S_AXI_GP_inst1");
S_AXI_GP_inst1 = new Zynq_AXI_GP_pvt("S_AXI_GP_inst1");
$end;
$create_component("sdhc_inst0");
sdhc_inst0 = new Zynq_SDHC_pvt("sdhc_inst0");
$end;
$create_component("sdhc_inst1");
sdhc_inst1 = new Zynq_SDHC_pvt("sdhc_inst1");
$end;
$create_component("apb_bus_inst01");
apb_bus_inst01 = new apb_bus_pvt("apb_bus_inst01");
$end;
$create_component("ttc0_inst");
ttc0_inst = new Cadence_TTC_pvt("ttc0_inst");
$end;
$create_component("gpio_inst0");
gpio_inst0 = new Zynq_GPIO_pvt("gpio_inst0");
$end;
$create_component("PS_inst");
PS_inst = new MEM_pvt("PS_inst");
$end;
$create_component("ddrc_inst0");
ddrc_inst0 = new Zynq_DDRC_pvt("ddrc_inst0");
$end;
$create_component("cpu_inst0");
cpu_inst0 = new CPU_HIER("cpu_inst0");
$end;
$create_component("ahb_bus_CI_inst00");
ahb_bus_CI_inst00 = new ahb_bus_CI_pvt("ahb_bus_CI_inst00");
$end;
$create_component("dmac_inst0");
dmac_inst0 = new DMA330_pvt("dmac_inst0");
$end;
$create_component("APB32toAPB16_bridge_inst00");
APB32toAPB16_bridge_inst00 = new APB32toAPB16_pvt("APB32toAPB16_bridge_inst00");
$end;
$create_component("APB32toAPB16_bridge_inst01");
APB32toAPB16_bridge_inst01 = new APB32toAPB16_pvt("APB32toAPB16_bridge_inst01");
$end;
$create_component("axi2ahb_bridge_inst00");
axi2ahb_bridge_inst00 = new AXI2AHB32_pvt("axi2ahb_bridge_inst00");
$end;
$create_component("axi2ahb_bridge_inst01");
axi2ahb_bridge_inst01 = new AXI2AHB32_pvt("axi2ahb_bridge_inst01");
$end;
$create_component("spi_inst0");
spi_inst0 = new Zynq_SPI_pvt("spi_inst0");
$end;
$create_component("spi_inst1");
spi_inst1 = new Zynq_SPI_pvt("spi_inst1");
$end;
$create_component("ahb2axi_bridge_inst00");
ahb2axi_bridge_inst00 = new AHB2AXI32_pvt("ahb2axi_bridge_inst00");
$end;
$create_component("trustzone_inst");
trustzone_inst = new Zynq_trustzone_pvt("trustzone_inst");
$end;
$create_component("axi2apb_bus_bridge00");
axi2apb_bus_bridge00 = new AXI2APB32_pvt("axi2apb_bus_bridge00");
$end;
$create_component("apb_bus_inst00");
apb_bus_inst00 = new apb_bus_pvt("apb_bus_inst00");
$end;
$create_component("ddrc_sf0");
ddrc_sf0 = new Zynq_DDRC_sf_pvt("ddrc_sf0");
$end;
$create_component("ocm_sf0");
ocm_sf0 = new Zynq_OCM_sf_pvt("ocm_sf0");
$end;
$create_component("apb_axi_usb1");
apb_axi_usb1 = new APB_AXI_pvt("apb_axi_usb1");
$end;
$create_component("apb_axi_usb0");
apb_axi_usb0 = new APB_AXI_pvt("apb_axi_usb0");
$end;
$create_component("USB1");
USB1 = new USB_EHCI_pvt("USB1");
$end;
$create_component("USB0");
USB0 = new USB_EHCI_pvt("USB0");
$end;
$create_component("apb_bus_usb");
apb_bus_usb = new APB_BUS_USB_pvt("apb_bus_usb");
$end;
$bind("PL12_IRQ","cpu_inst0->PL12_irq");
vista_bind(PL12_IRQ, cpu_inst0->PL12_irq);
$end;
$bind("axi_inst0->bus_master05","axi_bus_SI_inst00->axi_slave");
vista_bind(axi_inst0->bus_master05, axi_bus_SI_inst00->axi_slave);
$end;
$bind("PL13_IRQ","cpu_inst0->PL13_irq");
vista_bind(PL13_IRQ, cpu_inst0->PL13_irq);
$end;
$bind("AXI_HP_controllers->AXI_master0","HP_memory_interconnect->AXI_slave0");
vista_bind(AXI_HP_controllers->AXI_master0, HP_memory_interconnect->AXI_slave0);
$end;
$bind("PL14_IRQ","cpu_inst0->PL14_irq");
vista_bind(PL14_IRQ, cpu_inst0->PL14_irq);
$end;
$bind("PL6_IRQ","cpu_inst0->PL6_irq");
vista_bind(PL6_IRQ, cpu_inst0->PL6_irq);
$end;
$bind("S_AXI_HP0","AXI_HP_controllers->AXI_slave0");
vista_bind(S_AXI_HP0, AXI_HP_controllers->AXI_slave0);
$end;
$bind("PL15_IRQ","cpu_inst0->PL15_irq");
vista_bind(PL15_IRQ, cpu_inst0->PL15_irq);
$end;
$bind("uart_inst0->irq","cpu_inst0->uart0_irq");
vista_bind(uart_inst0->irq, cpu_inst0->uart0_irq);
$end;
$bind("PL2_IRQ","cpu_inst0->PL2_irq");
vista_bind(PL2_IRQ, cpu_inst0->PL2_irq);
$end;
$bind("uart_inst1->TX","console_inst1->RX");
vista_bind(uart_inst1->TX, console_inst1->RX);
$end;
$bind("S_AXI_HP3","AXI_HP_controllers->AXI_slave3");
vista_bind(S_AXI_HP3, AXI_HP_controllers->AXI_slave3);
$end;
$bind("APB32toAPB16_bridge_inst00->master_1","i2c_inst0->APB_Slave");
vista_bind(APB32toAPB16_bridge_inst00->master_1, i2c_inst0->APB_Slave);
$end;
$bind("dmac_inst0->irq_abort","cpu_inst0->dmac_abort");
vista_bind(dmac_inst0->irq_abort, cpu_inst0->dmac_abort);
$end;
$bind("qspi_inst0->IRQ","cpu_inst0->qspi0_irq");
vista_bind(qspi_inst0->IRQ, cpu_inst0->qspi0_irq);
$end;
$bind("ocm_inst0->IRQ","cpu_inst0->ocm_irq");
vista_bind(ocm_inst0->IRQ, cpu_inst0->ocm_irq);
$end;
$bind("apb_bus_inst01->apb_master10","PS_inst->slave");
vista_bind(apb_bus_inst01->apb_master10, PS_inst->slave);
$end;
$bind("axi_inst0->bus_master03","slcr_inst->host");
vista_bind(axi_inst0->bus_master03, slcr_inst->host);
$end;
$bind("PL9_IRQ","cpu_inst0->PL9_irq");
vista_bind(PL9_IRQ, cpu_inst0->PL9_irq);
$end;
$bind("Eth_inst1->Ethernet_irq","cpu_inst0->Ethernet1_irq");
vista_bind(Eth_inst1->Ethernet_irq, cpu_inst0->Ethernet1_irq);
$end;
$bind("ahb2axi_bridge_inst00->master_1","axi_inst0->bus_slave03");
vista_bind(ahb2axi_bridge_inst00->master_1, axi_inst0->bus_slave03);
$end;
$bind("axi_bus_SI_inst00->axi_master00","axi2ahb_bridge_inst00->slave_1");
vista_bind(axi_bus_SI_inst00->axi_master00, axi2ahb_bridge_inst00->slave_1);
$end;
$bind("APB32toAPB16_bridge_inst01->master_1","i2c_inst1->APB_Slave");
vista_bind(APB32toAPB16_bridge_inst01->master_1, i2c_inst1->APB_Slave);
$end;
$bind("cpu_inst0->master1","L2Cache->Slave0");
vista_bind(cpu_inst0->master1, L2Cache->Slave0);
$end;
$bind("S_AXI_GP0","S_AXI_GP_inst0->AXI_slave");
vista_bind(S_AXI_GP0, S_AXI_GP_inst0->AXI_slave);
$end;
$bind("PL5_IRQ","cpu_inst0->PL5_irq");
vista_bind(PL5_IRQ, cpu_inst0->PL5_irq);
$end;
$bind("ahb_bus_CI_inst00->ahb_master","ahb2axi_bridge_inst00->slave_1");
vista_bind(ahb_bus_CI_inst00->ahb_master, ahb2axi_bridge_inst00->slave_1);
$end;
$bind("apb_bus_inst01->apb_master01","ttc1_inst->apb");
vista_bind(apb_bus_inst01->apb_master01, ttc1_inst->apb);
$end;
$bind("AXI_HP_controllers->AXI_master3","HP_memory_interconnect->AXI_slave3");
vista_bind(AXI_HP_controllers->AXI_master3, HP_memory_interconnect->AXI_slave3);
$end;
$bind("axi_inst0->bus_master04","PS_apb->slave_1");
vista_bind(axi_inst0->bus_master04, PS_apb->slave_1);
$end;
$bind("spi_inst0->IRQ","cpu_inst0->spi0_irq");
vista_bind(spi_inst0->IRQ, cpu_inst0->spi0_irq);
$end;
$bind("Eth_inst0->Ethernet_irq","cpu_inst0->Ethernet0_irq");
vista_bind(Eth_inst0->Ethernet_irq, cpu_inst0->Ethernet0_irq);
$end;
$bind("gpio_inst0->IRQ","cpu_inst0->gpio_irq");
vista_bind(gpio_inst0->IRQ, cpu_inst0->gpio_irq);
$end;
$bind("PL1_IRQ","cpu_inst0->PL1_irq");
vista_bind(PL1_IRQ, cpu_inst0->PL1_irq);
$end;
$bind("dmac_inst0->AXI_master","axi_inst0->dma_slave02");
vista_bind(dmac_inst0->AXI_master, axi_inst0->dma_slave02);
$end;
$bind("spi_inst1->IRQ","cpu_inst0->spi1_irq");
vista_bind(spi_inst1->IRQ, cpu_inst0->spi1_irq);
$end;
$bind("console_inst0->TX","uart_inst0->RX");
vista_bind(console_inst0->TX, uart_inst0->RX);
$end;
$bind("ttc1_inst->irq3","cpu_inst0->ttc1_irq3");
vista_bind(ttc1_inst->irq3, cpu_inst0->ttc1_irq3);
$end;
$bind("sdhc_inst0->IRQ","cpu_inst0->sdhc0_irq");
vista_bind(sdhc_inst0->IRQ, cpu_inst0->sdhc0_irq);
$end;
$bind("axi_bus_SI_inst00->axi_master03","axi32toaxi64_bridge_inst00->slave_1");
vista_bind(axi_bus_SI_inst00->axi_master03, axi32toaxi64_bridge_inst00->slave_1);
$end;
$bind("S_AXI_GP_inst1->AXI_master","SlaveInterconnect0->bus_slave1");
vista_bind(S_AXI_GP_inst1->AXI_master, SlaveInterconnect0->bus_slave1);
$end;
$bind("PL8_IRQ","cpu_inst0->PL8_irq");
vista_bind(PL8_IRQ, cpu_inst0->PL8_irq);
$end;
$bind("axi_inst0->bus_master06","M_AXI_GP_inst0->AXI_slave");
vista_bind(axi_inst0->bus_master06, M_AXI_GP_inst0->AXI_slave);
$end;
$bind("apb_bus_inst01->apb_master06","AXI_HP_controllers->APB_slave2");
vista_bind(apb_bus_inst01->apb_master06, AXI_HP_controllers->APB_slave2);
$end;
$bind("Eth_inst0->Master","ahb_bus_CI_inst00->ahb_slave00");
vista_bind(Eth_inst0->Master, ahb_bus_CI_inst00->ahb_slave00);
$end;
$bind("ttc1_inst->irq1","cpu_inst0->ttc1_irq1");
vista_bind(ttc1_inst->irq1, cpu_inst0->ttc1_irq1);
$end;
$bind("dmac0_irq_split->output2","cpu_inst0->dmac_irq2");
vista_bind(dmac0_irq_split->output2, cpu_inst0->dmac_irq2);
$end;
$bind("dmac_inst0->irq","dmac0_irq_split->input");
vista_bind(dmac_inst0->irq, dmac0_irq_split->input);
$end;
$bind("axi2ahb_bridge_inst01->master_1","sdhc_inst1->AHB_Slave");
vista_bind(axi2ahb_bridge_inst01->master_1, sdhc_inst1->AHB_Slave);
$end;
$bind("ttc0_inst->irq3","cpu_inst0->ttc0_irq3");
vista_bind(ttc0_inst->irq3, cpu_inst0->ttc0_irq3);
$end;
$bind("S_AXI_GP1","S_AXI_GP_inst1->AXI_slave");
vista_bind(S_AXI_GP1, S_AXI_GP_inst1->AXI_slave);
$end;
$bind("S_AXI_GP_inst0->AXI_master","SlaveInterconnect0->bus_slave0");
vista_bind(S_AXI_GP_inst0->AXI_master, SlaveInterconnect0->bus_slave0);
$end;
$bind("axi_bus_SI_inst00->axi_master02","qspi_inst0->AXI");
vista_bind(axi_bus_SI_inst00->axi_master02, qspi_inst0->AXI);
$end;
$bind("dmac0_irq_split->output5","cpu_inst0->dmac_irq5");
vista_bind(dmac0_irq_split->output5, cpu_inst0->dmac_irq5);
$end;
$bind("sdhc_inst1->AHB_Master","ahb_bus_CI_inst00->ahb_slave03");
vista_bind(sdhc_inst1->AHB_Master, ahb_bus_CI_inst00->ahb_slave03);
$end;
$bind("PL4_IRQ","cpu_inst0->PL4_irq");
vista_bind(PL4_IRQ, cpu_inst0->PL4_irq);
$end;
$bind("S_AXI_ACP","cpu_inst0->ACP_slave");
vista_bind(S_AXI_ACP, cpu_inst0->ACP_slave);
$end;
$bind("apb_bus_inst01->apb_master03","ddrc_inst0->AMBA_APB");
vista_bind(apb_bus_inst01->apb_master03, ddrc_inst0->AMBA_APB);
$end;
$bind("apb_bus_inst01->apb_master05","AXI_HP_controllers->APB_slave1");
vista_bind(apb_bus_inst01->apb_master05, AXI_HP_controllers->APB_slave1);
$end;
$bind("cpu_inst0->master0","L2Cache->Slave1");
vista_bind(cpu_inst0->master0, L2Cache->Slave1);
$end;
$bind("dmac0_irq_split->output0","cpu_inst0->dmac_irq0");
vista_bind(dmac0_irq_split->output0, cpu_inst0->dmac_irq0);
$end;
$bind("sdhc_inst0->AHB_Master","ahb_bus_CI_inst00->ahb_slave02");
vista_bind(sdhc_inst0->AHB_Master, ahb_bus_CI_inst00->ahb_slave02);
$end;
$bind("ttc0_inst->irq1","cpu_inst0->ttc0_irq1");
vista_bind(ttc0_inst->irq1, cpu_inst0->ttc0_irq1);
$end;
$bind("PS_apb->master_1","apb_bus_inst01->apb_slave");
vista_bind(PS_apb->master_1, apb_bus_inst01->apb_slave);
$end;
$bind("M_AXI_GP_inst1->AXI_master","M_AXI_GP1");
vista_bind(M_AXI_GP_inst1->AXI_master, M_AXI_GP1);
$end;
$bind("ttc1_inst->irq2","cpu_inst0->ttc1_irq2");
vista_bind(ttc1_inst->irq2, cpu_inst0->ttc1_irq2);
$end;
$bind("dmac0_irq_split->output3","cpu_inst0->dmac_irq3");
vista_bind(dmac0_irq_split->output3, cpu_inst0->dmac_irq3);
$end;
$bind("PL0_IRQ","cpu_inst0->PL0_irq");
vista_bind(PL0_IRQ, cpu_inst0->PL0_irq);
$end;
$bind("apb_bus_inst01->apb_master04","AXI_HP_controllers->APB_slave0");
vista_bind(apb_bus_inst01->apb_master04, AXI_HP_controllers->APB_slave0);
$end;
$bind("sdhc_inst1->IRQ","cpu_inst0->sdhc1_irq");
vista_bind(sdhc_inst1->IRQ, cpu_inst0->sdhc1_irq);
$end;
$bind("dmac0_irq_split->output6","cpu_inst0->dmac_irq6");
vista_bind(dmac0_irq_split->output6, cpu_inst0->dmac_irq6);
$end;
$bind("slcr_inst->n_reset_1","cpu_inst0->n_reset_1");
vista_bind(slcr_inst->n_reset_1, cpu_inst0->n_reset_1);
$end;
$bind("i2c_inst0->IRQ","cpu_inst0->i2c0_irq");
vista_bind(i2c_inst0->IRQ, cpu_inst0->i2c0_irq);
$end;
$bind("apb_bus_inst01->apb_master02","dmac_inst0->APB_slave");
vista_bind(apb_bus_inst01->apb_master02, dmac_inst0->APB_slave);
$end;
$bind("M_AXI_GP_inst0->AXI_master","M_AXI_GP0");
vista_bind(M_AXI_GP_inst0->AXI_master, M_AXI_GP0);
$end;
$bind("dmac0_irq_split->output1","cpu_inst0->dmac_irq1");
vista_bind(dmac0_irq_split->output1, cpu_inst0->dmac_irq1);
$end;
$bind("PL7_IRQ","cpu_inst0->PL7_irq");
vista_bind(PL7_IRQ, cpu_inst0->PL7_irq);
$end;
$bind("ttc0_inst->irq2","cpu_inst0->ttc0_irq2");
vista_bind(ttc0_inst->irq2, cpu_inst0->ttc0_irq2);
$end;
$bind("axi32toaxi64_bridge_inst00->master_1","smc->AMBA_AXI");
vista_bind(axi32toaxi64_bridge_inst00->master_1, smc->AMBA_AXI);
$end;
$bind("axi2ahb_bridge_inst00->master_1","sdhc_inst0->AHB_Slave");
vista_bind(axi2ahb_bridge_inst00->master_1, sdhc_inst0->AHB_Slave);
$end;
$bind("axi_inst0->bus_master07","M_AXI_GP_inst1->AXI_slave");
vista_bind(axi_inst0->bus_master07, M_AXI_GP_inst1->AXI_slave);
$end;
$bind("i2c_inst1->IRQ","cpu_inst0->i2c1_irq");
vista_bind(i2c_inst1->IRQ, cpu_inst0->i2c1_irq);
$end;
$bind("dmac0_irq_split->output4","cpu_inst0->dmac_irq4");
vista_bind(dmac0_irq_split->output4, cpu_inst0->dmac_irq4);
$end;
$bind("apb_bus_inst01->apb_master07","AXI_HP_controllers->APB_slave3");
vista_bind(apb_bus_inst01->apb_master07, AXI_HP_controllers->APB_slave3);
$end;
$bind("AXI_HP_controllers->AXI_master2","HP_memory_interconnect->AXI_slave2");
vista_bind(AXI_HP_controllers->AXI_master2, HP_memory_interconnect->AXI_slave2);
$end;
$bind("dmac0_irq_split->output7","cpu_inst0->dmac_irq7");
vista_bind(dmac0_irq_split->output7, cpu_inst0->dmac_irq7);
$end;
$bind("uart_inst0->TX","console_inst0->RX");
vista_bind(uart_inst0->TX, console_inst0->RX);
$end;
$bind("axi_bus_SI_inst00->axi_master01","axi2ahb_bridge_inst01->slave_1");
vista_bind(axi_bus_SI_inst00->axi_master01, axi2ahb_bridge_inst01->slave_1);
$end;
$bind("PL3_IRQ","cpu_inst0->PL3_irq");
vista_bind(PL3_IRQ, cpu_inst0->PL3_irq);
$end;
$bind("SlaveInterconnect0->bus_master","axi_inst0->bus_slave04");
vista_bind(SlaveInterconnect0->bus_master, axi_inst0->bus_slave04);
$end;
$bind("apb_bus_inst01->apb_master00","ttc0_inst->apb");
vista_bind(apb_bus_inst01->apb_master00, ttc0_inst->apb);
$end;
$bind("S_AXI_HP2","AXI_HP_controllers->AXI_slave2");
vista_bind(S_AXI_HP2, AXI_HP_controllers->AXI_slave2);
$end;
$bind("AXI_HP_controllers->AXI_master1","HP_memory_interconnect->AXI_slave1");
vista_bind(AXI_HP_controllers->AXI_master1, HP_memory_interconnect->AXI_slave1);
$end;
$bind("apb_bus_inst01->apb_master08","ocm_inst0->APB_slave");
vista_bind(apb_bus_inst01->apb_master08, ocm_inst0->APB_slave);
$end;
$bind("PL10_IRQ","cpu_inst0->PL10_irq");
vista_bind(PL10_IRQ, cpu_inst0->PL10_irq);
$end;
$bind("smc->smc_int_0","cpu_inst0->smc_irq");
vista_bind(smc->smc_int_0, cpu_inst0->smc_irq);
$end;
$bind("console_inst1->TX","uart_inst1->RX");
vista_bind(console_inst1->TX, uart_inst1->RX);
$end;
$bind("S_AXI_HP1","AXI_HP_controllers->AXI_slave1");
vista_bind(S_AXI_HP1, AXI_HP_controllers->AXI_slave1);
$end;
$bind("uart_inst1->irq","cpu_inst0->uart1_irq");
vista_bind(uart_inst1->irq, cpu_inst0->uart1_irq);
$end;
$bind("PL11_IRQ","cpu_inst0->PL11_irq");
vista_bind(PL11_IRQ, cpu_inst0->PL11_irq);
$end;
$bind("Eth_inst1->Master","ahb_bus_CI_inst00->ahb_slave01");
vista_bind(Eth_inst1->Master, ahb_bus_CI_inst00->ahb_slave01);
$end;
$bind("axi_inst0->bus_master08","trustzone_inst->host");
vista_bind(axi_inst0->bus_master08, trustzone_inst->host);
$end;
$bind("trustzone_inst->out_peripheral_axi","axi_bus_SI_inst00->in_trustzone");
vista_bind(trustzone_inst->out_peripheral_axi, axi_bus_SI_inst00->in_trustzone);
$end;
$bind("trustzone_inst->out_peripheral_apb","apb_bus_inst00->in_trustzone");
vista_bind(trustzone_inst->out_peripheral_apb, apb_bus_inst00->in_trustzone);
$end;
$bind("apb_bus_inst00->apb_master08","gpio_inst0->APB");
vista_bind(apb_bus_inst00->apb_master08, gpio_inst0->APB);
$end;
$bind("apb_bus_inst00->apb_master02","Eth_inst0->Slave");
vista_bind(apb_bus_inst00->apb_master02, Eth_inst0->Slave);
$end;
$bind("apb_bus_inst00->apb_master01","uart_inst1->host");
vista_bind(apb_bus_inst00->apb_master01, uart_inst1->host);
$end;
$bind("axi2apb_bus_bridge00->master_1","apb_bus_inst00->apb_slave");
vista_bind(axi2apb_bus_bridge00->master_1, apb_bus_inst00->apb_slave);
$end;
$bind("apb_bus_inst00->apb_master07","smc->AMBA_APB");
vista_bind(apb_bus_inst00->apb_master07, smc->AMBA_APB);
$end;
$bind("apb_bus_inst00->apb_master09","APB32toAPB16_bridge_inst00->slave_1");
vista_bind(apb_bus_inst00->apb_master09, APB32toAPB16_bridge_inst00->slave_1);
$end;
$bind("apb_bus_inst00->apb_master10","APB32toAPB16_bridge_inst01->slave_1");
vista_bind(apb_bus_inst00->apb_master10, APB32toAPB16_bridge_inst01->slave_1);
$end;
$bind("axi_inst0->bus_master00","axi2apb_bus_bridge00->slave_1");
vista_bind(axi_inst0->bus_master00, axi2apb_bus_bridge00->slave_1);
$end;
$bind("apb_bus_inst00->apb_master04","spi_inst0->APB");
vista_bind(apb_bus_inst00->apb_master04, spi_inst0->APB);
$end;
$bind("apb_bus_inst00->apb_master03","Eth_inst1->Slave");
vista_bind(apb_bus_inst00->apb_master03, Eth_inst1->Slave);
$end;
$bind("apb_bus_inst00->apb_master00","uart_inst0->host");
vista_bind(apb_bus_inst00->apb_master00, uart_inst0->host);
$end;
$bind("apb_bus_inst00->apb_master06","qspi_inst0->APB");
vista_bind(apb_bus_inst00->apb_master06, qspi_inst0->APB);
$end;
$bind("apb_bus_inst00->apb_master05","spi_inst1->APB");
vista_bind(apb_bus_inst00->apb_master05, spi_inst1->APB);
$end;
$bind("L2Cache->Master1","axi_inst0->cpu_slave00");
vista_bind(L2Cache->Master1, axi_inst0->cpu_slave00);
$end;
$bind("L2Cache->Master0","axi_inst0->cpu_slave01");
vista_bind(L2Cache->Master0, axi_inst0->cpu_slave01);
$end;
$bind("L2Cache->L2CCINTR","cpu_inst0->l2cache_irq");
vista_bind(L2Cache->L2CCINTR, cpu_inst0->l2cache_irq);
$end;
$bind("HP_memory_interconnect->AXI_master1","ddrc_sf0->AXI_Slave2");
vista_bind(HP_memory_interconnect->AXI_master1, ddrc_sf0->AXI_Slave2);
$end;
$bind("HP_memory_interconnect->AXI_master0","ddrc_sf0->AXI_Slave3");
vista_bind(HP_memory_interconnect->AXI_master0, ddrc_sf0->AXI_Slave3);
$end;
$bind("ddrc_sf0->AXI_Master3","ddrc_inst0->AMBA_AXI3");
vista_bind(ddrc_sf0->AXI_Master3, ddrc_inst0->AMBA_AXI3);
$end;
$bind("ddrc_sf0->AXI_Master2","ddrc_inst0->AMBA_AXI2");
vista_bind(ddrc_sf0->AXI_Master2, ddrc_inst0->AMBA_AXI2);
$end;
$bind("ddrc_sf0->AXI_Master0","ddrc_inst0->AMBA_AXI0");
vista_bind(ddrc_sf0->AXI_Master0, ddrc_inst0->AMBA_AXI0);
$end;
$bind("ddrc_sf0->AXI_Master1","ddrc_inst0->AMBA_AXI1");
vista_bind(ddrc_sf0->AXI_Master1, ddrc_inst0->AMBA_AXI1);
$end;
$bind("axi_inst0->bus_master01","ddrc_sf0->AXI_Slave1");
vista_bind(axi_inst0->bus_master01, ddrc_sf0->AXI_Slave1);
$end;
$bind("slcr_inst->out_ddrc_adapter","ddrc_sf0->in_ddrc");
vista_bind(slcr_inst->out_ddrc_adapter, ddrc_sf0->in_ddrc);
$end;
$bind("HP_memory_interconnect->AXI_master2","ocm_sf0->AXI_Slave1");
vista_bind(HP_memory_interconnect->AXI_master2, ocm_sf0->AXI_Slave1);
$end;
$bind("ocm_sf0->AXI_Master0","ocm_inst0->AXI_slave0");
vista_bind(ocm_sf0->AXI_Master0, ocm_inst0->AXI_slave0);
$end;
$bind("slcr_inst->out_ocm_ram_adapter","ocm_sf0->in_ocm_ram");
vista_bind(slcr_inst->out_ocm_ram_adapter, ocm_sf0->in_ocm_ram);
$end;
$bind("axi_inst0->bus_master02","ocm_sf0->AXI_Slave0");
vista_bind(axi_inst0->bus_master02, ocm_sf0->AXI_Slave0);
$end;
$bind("ocm_sf0->AXI_Master1","ocm_inst0->AXI_slave1");
vista_bind(ocm_sf0->AXI_Master1, ocm_inst0->AXI_slave1);
$end;
$bind("slcr_inst->TZ_DMA_NS_s","dmac_inst0->boot_manager_ns");
vista_bind(slcr_inst->TZ_DMA_NS_s, dmac_inst0->boot_manager_ns);
$end;
$bind("slcr_inst->TZ_DMA_IRQ_NS_s","dmac_inst0->boot_irq_ns");
vista_bind(slcr_inst->TZ_DMA_IRQ_NS_s, dmac_inst0->boot_irq_ns);
$end;
$bind("slcr_inst->TZ_DMA_PERIPH_NS_s","dmac_inst0->boot_periph_ns");
vista_bind(slcr_inst->TZ_DMA_PERIPH_NS_s, dmac_inst0->boot_periph_ns);
$end;
$bind("GPIN0","gpio_inst0->GPIN0");
vista_bind(GPIN0, gpio_inst0->GPIN0);
$end;
$bind("GPIN2","gpio_inst0->GPIN2");
vista_bind(GPIN2, gpio_inst0->GPIN2);
$end;
$bind("gpio_inst0->GPOUT0","GPOUT0");
vista_bind(gpio_inst0->GPOUT0, GPOUT0);
$end;
$bind("gpio_inst0->GPOUT1","GPOUT1");
vista_bind(gpio_inst0->GPOUT1, GPOUT1);
$end;
$bind("gpio_inst0->GPOUT2","GPOUT2");
vista_bind(gpio_inst0->GPOUT2, GPOUT2);
$end;
$bind("gpio_inst0->GPOUT3","GPOUT3");
vista_bind(gpio_inst0->GPOUT3, GPOUT3);
$end;
$bind("GPIN1","gpio_inst0->GPIN1");
vista_bind(GPIN1, gpio_inst0->GPIN1);
$end;
$bind("GPIN3","gpio_inst0->GPIN3");
vista_bind(GPIN3, gpio_inst0->GPIN3);
$end;
$bind("apb_bus_inst01->apb_master11","dmac_inst0->APB_NonSecure_slave");
vista_bind(apb_bus_inst01->apb_master11, dmac_inst0->APB_NonSecure_slave);
$end;
$bind("USB1->dma_port","ahb_bus_CI_inst00->ahb_slave05");
vista_bind(USB1->dma_port, ahb_bus_CI_inst00->ahb_slave05);
$end;
$bind("apb_axi_usb0->master","USB0->host");
vista_bind(apb_axi_usb0->master, USB0->host);
$end;
$bind("USB0->dma_port","ahb_bus_CI_inst00->ahb_slave04");
vista_bind(USB0->dma_port, ahb_bus_CI_inst00->ahb_slave04);
$end;
$bind("apb_axi_usb1->master","USB1->host");
vista_bind(apb_axi_usb1->master, USB1->host);
$end;
$bind("apb_bus_inst00->apb_master11","apb_bus_usb->bus_slave");
vista_bind(apb_bus_inst00->apb_master11, apb_bus_usb->bus_slave);
$end;
$bind("apb_bus_usb->bus_master_0","apb_axi_usb0->slave");
vista_bind(apb_bus_usb->bus_master_0, apb_axi_usb0->slave);
$end;
$bind("apb_bus_usb->bus_master_1","apb_axi_usb1->slave");
vista_bind(apb_bus_usb->bus_master_1, apb_axi_usb1->slave);
$end;
$bind("USB1->irq","cpu_inst0->usb1_irq");
vista_bind(USB1->irq, cpu_inst0->usb1_irq);
$end;
$bind("USB0->irq","cpu_inst0->usb0_irq");
vista_bind(USB0->irq, cpu_inst0->usb0_irq);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "schematics";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~Zynq_SoC() {
    $destructor_begin;
$destruct_component("HP_memory_interconnect");
delete HP_memory_interconnect; HP_memory_interconnect = 0;
$end;
$destruct_component("axi_inst0");
delete axi_inst0; axi_inst0 = 0;
$end;
$destruct_component("i2c_inst0");
delete i2c_inst0; i2c_inst0 = 0;
$end;
$destruct_component("slcr_inst");
delete slcr_inst; slcr_inst = 0;
$end;
$destruct_component("i2c_inst1");
delete i2c_inst1; i2c_inst1 = 0;
$end;
$destruct_component("dmac0_irq_split");
delete dmac0_irq_split; dmac0_irq_split = 0;
$end;
$destruct_component("smc");
delete smc; smc = 0;
$end;
$destruct_component("qspi_inst0");
delete qspi_inst0; qspi_inst0 = 0;
$end;
$destruct_component("axi_bus_SI_inst00");
delete axi_bus_SI_inst00; axi_bus_SI_inst00 = 0;
$end;
$destruct_component("ttc1_inst");
delete ttc1_inst; ttc1_inst = 0;
$end;
$destruct_component("L2Cache");
delete L2Cache; L2Cache = 0;
$end;
$destruct_component("PS_apb");
delete PS_apb; PS_apb = 0;
$end;
$destruct_component("AXI_HP_controllers");
delete AXI_HP_controllers; AXI_HP_controllers = 0;
$end;
$destruct_component("console_inst0");
delete console_inst0; console_inst0 = 0;
$end;
$destruct_component("console_inst1");
delete console_inst1; console_inst1 = 0;
$end;
$destruct_component("axi32toaxi64_bridge_inst00");
delete axi32toaxi64_bridge_inst00; axi32toaxi64_bridge_inst00 = 0;
$end;
$destruct_component("ocm_inst0");
delete ocm_inst0; ocm_inst0 = 0;
$end;
$destruct_component("uart_inst0");
delete uart_inst0; uart_inst0 = 0;
$end;
$destruct_component("M_AXI_GP_inst0");
delete M_AXI_GP_inst0; M_AXI_GP_inst0 = 0;
$end;
$destruct_component("uart_inst1");
delete uart_inst1; uart_inst1 = 0;
$end;
$destruct_component("SlaveInterconnect0");
delete SlaveInterconnect0; SlaveInterconnect0 = 0;
$end;
$destruct_component("M_AXI_GP_inst1");
delete M_AXI_GP_inst1; M_AXI_GP_inst1 = 0;
$end;
$destruct_component("Eth_inst0");
delete Eth_inst0; Eth_inst0 = 0;
$end;
$destruct_component("Eth_inst1");
delete Eth_inst1; Eth_inst1 = 0;
$end;
$destruct_component("S_AXI_GP_inst0");
delete S_AXI_GP_inst0; S_AXI_GP_inst0 = 0;
$end;
$destruct_component("S_AXI_GP_inst1");
delete S_AXI_GP_inst1; S_AXI_GP_inst1 = 0;
$end;
$destruct_component("sdhc_inst0");
delete sdhc_inst0; sdhc_inst0 = 0;
$end;
$destruct_component("sdhc_inst1");
delete sdhc_inst1; sdhc_inst1 = 0;
$end;
$destruct_component("apb_bus_inst01");
delete apb_bus_inst01; apb_bus_inst01 = 0;
$end;
$destruct_component("ttc0_inst");
delete ttc0_inst; ttc0_inst = 0;
$end;
$destruct_component("gpio_inst0");
delete gpio_inst0; gpio_inst0 = 0;
$end;
$destruct_component("PS_inst");
delete PS_inst; PS_inst = 0;
$end;
$destruct_component("ddrc_inst0");
delete ddrc_inst0; ddrc_inst0 = 0;
$end;
$destruct_component("cpu_inst0");
delete cpu_inst0; cpu_inst0 = 0;
$end;
$destruct_component("ahb_bus_CI_inst00");
delete ahb_bus_CI_inst00; ahb_bus_CI_inst00 = 0;
$end;
$destruct_component("dmac_inst0");
delete dmac_inst0; dmac_inst0 = 0;
$end;
$destruct_component("APB32toAPB16_bridge_inst00");
delete APB32toAPB16_bridge_inst00; APB32toAPB16_bridge_inst00 = 0;
$end;
$destruct_component("APB32toAPB16_bridge_inst01");
delete APB32toAPB16_bridge_inst01; APB32toAPB16_bridge_inst01 = 0;
$end;
$destruct_component("axi2ahb_bridge_inst00");
delete axi2ahb_bridge_inst00; axi2ahb_bridge_inst00 = 0;
$end;
$destruct_component("axi2ahb_bridge_inst01");
delete axi2ahb_bridge_inst01; axi2ahb_bridge_inst01 = 0;
$end;
$destruct_component("spi_inst0");
delete spi_inst0; spi_inst0 = 0;
$end;
$destruct_component("spi_inst1");
delete spi_inst1; spi_inst1 = 0;
$end;
$destruct_component("ahb2axi_bridge_inst00");
delete ahb2axi_bridge_inst00; ahb2axi_bridge_inst00 = 0;
$end;
$destruct_component("trustzone_inst");
delete trustzone_inst; trustzone_inst = 0;
$end;
$destruct_component("axi2apb_bus_bridge00");
delete axi2apb_bus_bridge00; axi2apb_bus_bridge00 = 0;
$end;
$destruct_component("apb_bus_inst00");
delete apb_bus_inst00; apb_bus_inst00 = 0;
$end;
$destruct_component("ddrc_sf0");
delete ddrc_sf0; ddrc_sf0 = 0;
$end;
$destruct_component("ocm_sf0");
delete ocm_sf0; ocm_sf0 = 0;
$end;
$destruct_component("apb_axi_usb1");
delete apb_axi_usb1; apb_axi_usb1 = 0;
$end;
$destruct_component("apb_axi_usb0");
delete apb_axi_usb0; apb_axi_usb0 = 0;
$end;
$destruct_component("USB1");
delete USB1; USB1 = 0;
$end;
$destruct_component("USB0");
delete USB0; USB0 = 0;
$end;
$destruct_component("apb_bus_usb");
delete apb_bus_usb; apb_bus_usb = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$socket("S_AXI_ACP");
tlm::tlm_target_socket< 64U,axi_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > S_AXI_ACP;
$end;
$socket("PL7_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL7_IRQ;
$end;
$socket("PL4_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL4_IRQ;
$end;
$socket("PL14_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL14_IRQ;
$end;
$socket("PL1_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL1_IRQ;
$end;
$socket("PL11_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL11_IRQ;
$end;
$socket("PL8_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL8_IRQ;
$end;
$socket("PL5_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL5_IRQ;
$end;
$socket("PL2_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL2_IRQ;
$end;
$socket("PL13_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL13_IRQ;
$end;
$socket("PL10_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL10_IRQ;
$end;
$socket("S_AXI_GP0");
tlm::tlm_target_socket< 32U,axi_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > S_AXI_GP0;
$end;
$socket("S_AXI_GP1");
tlm::tlm_target_socket< 32U,axi_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > S_AXI_GP1;
$end;
$socket("S_AXI_HP0");
tlm::tlm_target_socket< 64U,axi_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > S_AXI_HP0;
$end;
$socket("S_AXI_HP1");
tlm::tlm_target_socket< 64U,axi_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > S_AXI_HP1;
$end;
$socket("S_AXI_HP2");
tlm::tlm_target_socket< 64U,axi_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > S_AXI_HP2;
$end;
$socket("S_AXI_HP3");
tlm::tlm_target_socket< 64U,axi_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > S_AXI_HP3;
$end;
$socket("PL15_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL15_IRQ;
$end;
$socket("PL9_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL9_IRQ;
$end;
$socket("PL6_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL6_IRQ;
$end;
$socket("PL3_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL3_IRQ;
$end;
$socket("PL0_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL0_IRQ;
$end;
$socket("PL12_IRQ");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > PL12_IRQ;
$end;
$socket("GPIN1");
tlm::tlm_target_socket< 32U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > GPIN1;
$end;
$socket("GPIN3");
tlm::tlm_target_socket< 32U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > GPIN3;
$end;
$socket("GPIN0");
tlm::tlm_target_socket< 32U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > GPIN0;
$end;
$socket("GPIN2");
tlm::tlm_target_socket< 32U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > GPIN2;
$end;
$socket("M_AXI_GP0");
tlm::tlm_initiator_socket< 32U,axi_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > M_AXI_GP0;
$end;
$socket("M_AXI_GP1");
tlm::tlm_initiator_socket< 32U,axi_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > M_AXI_GP1;
$end;
$socket("GPOUT1");
tlm::tlm_initiator_socket< 32U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > GPOUT1;
$end;
$socket("GPOUT2");
tlm::tlm_initiator_socket< 32U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > GPOUT2;
$end;
$socket("GPOUT0");
tlm::tlm_initiator_socket< 32U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > GPOUT0;
$end;
$socket("GPOUT3");
tlm::tlm_initiator_socket< 32U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > GPOUT3;
$end;
$component("HP_memory_interconnect");
Memory_Interconnect_pvt *HP_memory_interconnect;
$end;
$component("axi_inst0");
axi_bus_pvt *axi_inst0;
$end;
$component("i2c_inst0");
Zynq_I2C_pvt *i2c_inst0;
$end;
$component("slcr_inst");
zynq_slcr_pvt *slcr_inst;
$end;
$component("i2c_inst1");
Zynq_I2C_pvt *i2c_inst1;
$end;
$component("dmac0_irq_split");
dma_irq_splitter_pvt *dmac0_irq_split;
$end;
$component("smc");
SMC_PL350_pvt *smc;
$end;
$component("qspi_inst0");
Zynq_QSPI_pvt *qspi_inst0;
$end;
$component("axi_bus_SI_inst00");
AXI_bus_SI_pvt *axi_bus_SI_inst00;
$end;
$component("ttc1_inst");
Cadence_TTC_pvt *ttc1_inst;
$end;
$component("L2Cache");
PL310_pvt *L2Cache;
$end;
$component("PS_apb");
AXI2APB32_pvt *PS_apb;
$end;
$component("AXI_HP_controllers");
AXI_HP_Controllers *AXI_HP_controllers;
$end;
$component("console_inst0");
Console_pvt *console_inst0;
$end;
$component("console_inst1");
Console_pvt *console_inst1;
$end;
$component("axi32toaxi64_bridge_inst00");
AXI32toAXI64_pvt *axi32toaxi64_bridge_inst00;
$end;
$component("ocm_inst0");
Zynq_OCM_pvt *ocm_inst0;
$end;
$component("uart_inst0");
Cadence_UART_pvt *uart_inst0;
$end;
$component("M_AXI_GP_inst0");
Zynq_AXI_GP_pvt *M_AXI_GP_inst0;
$end;
$component("uart_inst1");
Cadence_UART_pvt *uart_inst1;
$end;
$component("SlaveInterconnect0");
Slave_Interconnect_pvt *SlaveInterconnect0;
$end;
$component("M_AXI_GP_inst1");
Zynq_AXI_GP_pvt *M_AXI_GP_inst1;
$end;
$component("Eth_inst0");
Zynq_GEM_pvt *Eth_inst0;
$end;
$component("Eth_inst1");
Zynq_GEM_pvt *Eth_inst1;
$end;
$component("S_AXI_GP_inst0");
Zynq_AXI_GP_pvt *S_AXI_GP_inst0;
$end;
$component("S_AXI_GP_inst1");
Zynq_AXI_GP_pvt *S_AXI_GP_inst1;
$end;
$component("sdhc_inst0");
Zynq_SDHC_pvt *sdhc_inst0;
$end;
$component("sdhc_inst1");
Zynq_SDHC_pvt *sdhc_inst1;
$end;
$component("apb_bus_inst01");
apb_bus_pvt *apb_bus_inst01;
$end;
$component("ttc0_inst");
Cadence_TTC_pvt *ttc0_inst;
$end;
$component("gpio_inst0");
Zynq_GPIO_pvt *gpio_inst0;
$end;
$component("PS_inst");
MEM_pvt *PS_inst;
$end;
$component("ddrc_inst0");
Zynq_DDRC_pvt *ddrc_inst0;
$end;
$component("cpu_inst0");
CPU_HIER *cpu_inst0;
$end;
$component("ahb_bus_CI_inst00");
ahb_bus_CI_pvt *ahb_bus_CI_inst00;
$end;
$component("dmac_inst0");
DMA330_pvt *dmac_inst0;
$end;
$component("APB32toAPB16_bridge_inst00");
APB32toAPB16_pvt *APB32toAPB16_bridge_inst00;
$end;
$component("APB32toAPB16_bridge_inst01");
APB32toAPB16_pvt *APB32toAPB16_bridge_inst01;
$end;
$component("axi2ahb_bridge_inst00");
AXI2AHB32_pvt *axi2ahb_bridge_inst00;
$end;
$component("axi2ahb_bridge_inst01");
AXI2AHB32_pvt *axi2ahb_bridge_inst01;
$end;
$component("spi_inst0");
Zynq_SPI_pvt *spi_inst0;
$end;
$component("spi_inst1");
Zynq_SPI_pvt *spi_inst1;
$end;
$component("ahb2axi_bridge_inst00");
AHB2AXI32_pvt *ahb2axi_bridge_inst00;
$end;
$component("trustzone_inst");
Zynq_trustzone_pvt *trustzone_inst;
$end;
$component("axi2apb_bus_bridge00");
AXI2APB32_pvt *axi2apb_bus_bridge00;
$end;
$component("apb_bus_inst00");
apb_bus_pvt *apb_bus_inst00;
$end;
$component("ddrc_sf0");
Zynq_DDRC_sf_pvt *ddrc_sf0;
$end;
$component("ocm_sf0");
Zynq_OCM_sf_pvt *ocm_sf0;
$end;
$component("apb_axi_usb1");
APB_AXI_pvt *apb_axi_usb1;
$end;
$component("apb_axi_usb0");
APB_AXI_pvt *apb_axi_usb0;
$end;
$component("USB1");
USB_EHCI_pvt *USB1;
$end;
$component("USB0");
USB_EHCI_pvt *USB0;
$end;
$component("apb_bus_usb");
APB_BUS_USB_pvt *apb_bus_usb;
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