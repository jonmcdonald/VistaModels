#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "iMX6_models/i_mx6_ipu_model.h"
#include "iMX6_models/i_mx6_asrc_model.h"
#include "iMX6_models/SPI_FLASH_model.h"
#include "iMX6_models/i_mx6_ecspi_model.h"
#include "iMX6_models/usb_otg_model.h"
#include "iMX6_models/i_mx6_iomuxc_model.h"
#include "iMX6_models/i_mx6_snvs_model.h"
#include "iMX6_models/EEPROM_model.h"
#include "iMX6_models/i_mx6_ccm_model.h"
#include "iMX6_models/ext_memory_model.h"
#include "iMX6_models/PL310_model.h"
#include "iMX6_models/i_mx6_ssi_model.h"
#include "iMX6_models/i_mx6_spdif_model.h"
#include "iMX6_models/axi_bus_model.h"
#include "iMX6_models/i_mx6_usdhc_model.h"
#include "iMX6_models/i_mx6_audmux_model.h"
#include "iMX6_models/i_mx6_wdog_model.h"
#include "iMX6_models/i_mx6_gpio_model.h"
#include "iMX6_models/Cortex_A9MP_model.h"
#include "iMX6_models/i_mx6_sata_model.h"
#include "iMX6_models/IPU_br_model.h"
#include "iMX6_models/USBNC_model.h"
#include "iMX6_models/ocram_model.h"
#include "iMX6_models/i_mx6_hdmi_model.h"
#include "iMX6_models/i_mx6_gpc_model.h"
#include "iMX6_models/i_mx6_epit_model.h"
#include "iMX6_models/usb_br_model.h"
#include "iMX6_models/usb_host_model.h"
#include "iMX6_models/apbh_bus_model.h"
#include "iMX6_models/ddr_memory_model.h"
#include "iMX6_models/i_mx6_gpt_model.h"
#include "iMX6_models/ahb2axi32_model.h"
#include "iMX6_models/i_mx6_enet_model.h"
#include "iMX6_models/axi2ahb_model.h"
#include "iMX6_models/i_mx6_AHB2APBH_model.h"
#include "iMX6_models/i_mx6_sdma_model.h"
#include "iMX6_models/i_mx6_pcie_model.h"
#include "iMX6_models/AXI2AHP_br_model.h"
#include "iMX6_models/i_mx6_ocotp_ctrl_model.h"
#include "iMX6_models/i_mx6_usbphy_model.h"
#include "iMX6_models/i_mx6_mmdc_model.h"
#include "iMX6_models/i_mx6_i2c_model.h"
#include "iMX6_models/i_mx6_src_model.h"
#include "iMX6_models/AXI2GENERIC_br_model.h"
#include "iMX6_models/i_mx6_uart_model.h"
#include "iMX6_models/ahb2ip_model.h"
#include "iMX6_models/ip_bus_model.h"
#include "iMX6_models/hdmi_br_model.h"
#include "iMX6_models/rom_model.h"
#include "iMX6_models/i_mx6_pwm_model.h"
#include "iMX6_models/ahb_bus_model.h"
#include "iMX6_models/ip2apb_model.h"
$includes_end;

$module_begin("i_mx6sl_top");
SC_MODULE(i_mx6sl_top) {
public:
  i_mx6sl_top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("AHB_BUS"),
AHB_BUS(0)
$end
$init("IP_BUS"),
IP_BUS(0)
$end
$init("uSDHC1"),
uSDHC1(0)
$end
$init("uSDHC4"),
uSDHC4(0)
$end
$init("L2C_PL310"),
L2C_PL310(0)
$end
$init("AHB2IP"),
AHB2IP(0)
$end
$init("uSDHC3"),
uSDHC3(0)
$end
$init("AXI2AHB"),
AXI2AHB(0)
$end
$init("CORTEX_A9MP"),
CORTEX_A9MP(0)
$end
$init("AXI_BUS"),
AXI_BUS(0)
$end
$init("uSDHC2"),
uSDHC2(0)
$end
$init("GPIO4"),
GPIO4(0)
$end
$init("GPIO3"),
GPIO3(0)
$end
$init("GPIO2"),
GPIO2(0)
$end
$init("GPIO1"),
GPIO1(0)
$end
$init("GPIO5"),
GPIO5(0)
$end
$init("OCRAM"),
OCRAM(0)
$end
$init("ROM"),
ROM(0)
$end
$init("DDR_MEM"),
DDR_MEM(0)
$end
$init("EXT_MEM"),
EXT_MEM(0)
$end
$init("USB_OTG"),
USB_OTG(0)
$end
$init("USB_HOST1"),
USB_HOST1(0)
$end
$init("GPT"),
GPT(0)
$end
$init("WDOG2"),
WDOG2(0)
$end
$init("WDOG1"),
WDOG1(0)
$end
$init("UART5"),
UART5(0)
$end
$init("UART1"),
UART1(0)
$end
$init("UART2"),
UART2(0)
$end
$init("UART3"),
UART3(0)
$end
$init("UART4"),
UART4(0)
$end
$init("I2C3"),
I2C3(0)
$end
$init("I2C2"),
I2C2(0)
$end
$init("I2C1"),
I2C1(0)
$end
$init("SDMA"),
SDMA(0)
$end
$init("SPDIF"),
SPDIF(0)
$end
$init("EPIT1"),
EPIT1(0)
$end
$init("EPIT2"),
EPIT2(0)
$end
$init("CCM"),
CCM(0)
$end
$init("sd_br1"),
sd_br1(0)
$end
$init("sd_br2"),
sd_br2(0)
$end
$init("sd_br3"),
sd_br3(0)
$end
$init("sd_br4"),
sd_br4(0)
$end
$init("IOMUXC"),
IOMUXC(0)
$end
$init("GPIO6"),
GPIO6(0)
$end
$init("GPIO7"),
GPIO7(0)
$end
$init("USB_HOST2"),
USB_HOST2(0)
$end
$init("USB_HOST3"),
USB_HOST3(0)
$end
$init("ENET"),
ENET(0)
$end
$init("enet_br"),
enet_br(0)
$end
$init("PWM2"),
PWM2(0)
$end
$init("PWM4"),
PWM4(0)
$end
$init("PWM1"),
PWM1(0)
$end
$init("PWM3"),
PWM3(0)
$end
$init("ECSPI2"),
ECSPI2(0)
$end
$init("SRC"),
SRC(0)
$end
$init("ECSPI5"),
ECSPI5(0)
$end
$init("ECSPI3"),
ECSPI3(0)
$end
$init("IPU1"),
IPU1(0)
$end
$init("ECSPI1"),
ECSPI1(0)
$end
$init("ECSPI4"),
ECSPI4(0)
$end
$init("EEPROM2"),
EEPROM2(0)
$end
$init("EEPROM3"),
EEPROM3(0)
$end
$init("IPU1_br"),
IPU1_br(0)
$end
$init("OCOTP_CTRL"),
OCOTP_CTRL(0)
$end
$init("MMDC1"),
MMDC1(0)
$end
$init("SNVS"),
SNVS(0)
$end
$init("MMDC2"),
MMDC2(0)
$end
$init("GPC"),
GPC(0)
$end
$init("PCIe_br"),
PCIe_br(0)
$end
$init("PCIe"),
PCIe(0)
$end
$init("SATA_br"),
SATA_br(0)
$end
$init("SATA"),
SATA(0)
$end
$init("USB_PHY1"),
USB_PHY1(0)
$end
$init("USB_PHY2"),
USB_PHY2(0)
$end
$init("USB_PHY1_br"),
USB_PHY1_br(0)
$end
$init("AUDMUX"),
AUDMUX(0)
$end
$init("USB_PHY2_br"),
USB_PHY2_br(0)
$end
$init("HDMI_br"),
HDMI_br(0)
$end
$init("HDMI"),
HDMI(0)
$end
$init("SSI1"),
SSI1(0)
$end
$init("SSI2"),
SSI2(0)
$end
$init("SSI3"),
SSI3(0)
$end
$init("FLASH"),
FLASH(0)
$end
$init("USBNC"),
USBNC(0)
$end
$init("IPU2"),
IPU2(0)
$end
$init("IPU2_br"),
IPU2_br(0)
$end
$init("HOST2_br"),
HOST2_br(0)
$end
$init("OTG_br"),
OTG_br(0)
$end
$init("HOST3_br"),
HOST3_br(0)
$end
$init("AHB2APBH"),
AHB2APBH(0)
$end
$init("APBH_BUS"),
APBH_BUS(0)
$end
$init("ASRC"),
ASRC(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("AHB_BUS");
AHB_BUS = new ahb_bus_pvt("AHB_BUS");
$end;
$create_component("IP_BUS");
IP_BUS = new ip_bus_pvt("IP_BUS");
$end;
$create_component("uSDHC1");
uSDHC1 = new i_mx6_usdhc_pvt("uSDHC1");
$end;
$create_component("uSDHC4");
uSDHC4 = new i_mx6_usdhc_pvt("uSDHC4");
$end;
$create_component("L2C_PL310");
L2C_PL310 = new PL310_pvt("L2C_PL310");
$end;
$create_component("AHB2IP");
AHB2IP = new ahb2ip_pvt("AHB2IP");
$end;
$create_component("uSDHC3");
uSDHC3 = new i_mx6_usdhc_pvt("uSDHC3");
$end;
$create_component("AXI2AHB");
AXI2AHB = new axi2ahb_pvt("AXI2AHB");
$end;
$create_component("CORTEX_A9MP");
CORTEX_A9MP = new Cortex_A9MP_pvt("CORTEX_A9MP");
$end;
$create_component("AXI_BUS");
AXI_BUS = new axi_bus_pvt("AXI_BUS");
$end;
$create_component("uSDHC2");
uSDHC2 = new i_mx6_usdhc_pvt("uSDHC2");
$end;
$create_component("GPIO4");
GPIO4 = new i_mx6_gpio_pvt("GPIO4");
$end;
$create_component("GPIO3");
GPIO3 = new i_mx6_gpio_pvt("GPIO3");
$end;
$create_component("GPIO2");
GPIO2 = new i_mx6_gpio_pvt("GPIO2");
$end;
$create_component("GPIO1");
GPIO1 = new i_mx6_gpio_pvt("GPIO1");
$end;
$create_component("GPIO5");
GPIO5 = new i_mx6_gpio_pvt("GPIO5");
$end;
$create_component("OCRAM");
OCRAM = new ocram_pvt("OCRAM");
$end;
$create_component("ROM");
ROM = new rom_pvt("ROM");
$end;
$create_component("DDR_MEM");
DDR_MEM = new ddr_memory_pvt("DDR_MEM");
$end;
$create_component("EXT_MEM");
EXT_MEM = new ext_memory_pvt("EXT_MEM");
$end;
$create_component("USB_OTG");
USB_OTG = new usb_otg_pvt("USB_OTG");
$end;
$create_component("USB_HOST1");
USB_HOST1 = new usb_host_pvt("USB_HOST1");
$end;
$create_component("GPT");
GPT = new i_mx6_gpt_pvt("GPT");
$end;
$create_component("WDOG2");
WDOG2 = new i_mx6_wdog_pvt("WDOG2");
$end;
$create_component("WDOG1");
WDOG1 = new i_mx6_wdog_pvt("WDOG1");
$end;
$create_component("UART5");
UART5 = new i_mx6_uart_pvt("UART5");
$end;
$create_component("UART1");
UART1 = new i_mx6_uart_pvt("UART1");
$end;
$create_component("UART2");
UART2 = new i_mx6_uart_pvt("UART2");
$end;
$create_component("UART3");
UART3 = new i_mx6_uart_pvt("UART3");
$end;
$create_component("UART4");
UART4 = new i_mx6_uart_pvt("UART4");
$end;
$create_component("I2C3");
I2C3 = new i_mx6_i2c_pvt("I2C3");
$end;
$create_component("I2C2");
I2C2 = new i_mx6_i2c_pvt("I2C2");
$end;
$create_component("I2C1");
I2C1 = new i_mx6_i2c_pvt("I2C1");
$end;
$create_component("SDMA");
SDMA = new i_mx6_sdma_pvt("SDMA");
$end;
$create_component("SPDIF");
SPDIF = new i_mx6_spdif_pvt("SPDIF");
$end;
$create_component("EPIT1");
EPIT1 = new i_mx6_epit_pvt("EPIT1");
$end;
$create_component("EPIT2");
EPIT2 = new i_mx6_epit_pvt("EPIT2");
$end;
$create_component("CCM");
CCM = new i_mx6_ccm_pvt("CCM");
$end;
$create_component("sd_br1");
sd_br1 = new ahb2axi32_pvt("sd_br1");
$end;
$create_component("sd_br2");
sd_br2 = new ahb2axi32_pvt("sd_br2");
$end;
$create_component("sd_br3");
sd_br3 = new ahb2axi32_pvt("sd_br3");
$end;
$create_component("sd_br4");
sd_br4 = new ahb2axi32_pvt("sd_br4");
$end;
$create_component("IOMUXC");
IOMUXC = new i_mx6_iomuxc_pvt("IOMUXC");
$end;
$create_component("GPIO6");
GPIO6 = new i_mx6_gpio_pvt("GPIO6");
$end;
$create_component("GPIO7");
GPIO7 = new i_mx6_gpio_pvt("GPIO7");
$end;
$create_component("USB_HOST2");
USB_HOST2 = new usb_host_pvt("USB_HOST2");
$end;
$create_component("USB_HOST3");
USB_HOST3 = new usb_host_pvt("USB_HOST3");
$end;
$create_component("ENET");
ENET = new i_mx6_enet_pvt("ENET");
$end;
$create_component("enet_br");
enet_br = new ahb2axi32_pvt("enet_br");
$end;
$create_component("PWM2");
PWM2 = new i_mx6_pwm_pvt("PWM2");
$end;
$create_component("PWM4");
PWM4 = new i_mx6_pwm_pvt("PWM4");
$end;
$create_component("PWM1");
PWM1 = new i_mx6_pwm_pvt("PWM1");
$end;
$create_component("PWM3");
PWM3 = new i_mx6_pwm_pvt("PWM3");
$end;
$create_component("ECSPI2");
ECSPI2 = new i_mx6_ecspi_pvt("ECSPI2");
$end;
$create_component("SRC");
SRC = new i_mx6_src_pvt("SRC");
$end;
$create_component("ECSPI5");
ECSPI5 = new i_mx6_ecspi_pvt("ECSPI5");
$end;
$create_component("ECSPI3");
ECSPI3 = new i_mx6_ecspi_pvt("ECSPI3");
$end;
$create_component("IPU1");
IPU1 = new i_mx6_ipu_pvt("IPU1");
$end;
$create_component("ECSPI1");
ECSPI1 = new i_mx6_ecspi_pvt("ECSPI1");
$end;
$create_component("ECSPI4");
ECSPI4 = new i_mx6_ecspi_pvt("ECSPI4");
$end;
$create_component("EEPROM2");
EEPROM2 = new EEPROM_pvt("EEPROM2");
$end;
$create_component("EEPROM3");
EEPROM3 = new EEPROM_pvt("EEPROM3");
$end;
$create_component("IPU1_br");
IPU1_br = new IPU_br_pvt("IPU1_br");
$end;
$create_component("OCOTP_CTRL");
OCOTP_CTRL = new i_mx6_ocotp_ctrl_pvt("OCOTP_CTRL");
$end;
$create_component("MMDC1");
MMDC1 = new i_mx6_mmdc_pvt("MMDC1");
$end;
$create_component("SNVS");
SNVS = new i_mx6_snvs_pvt("SNVS");
$end;
$create_component("MMDC2");
MMDC2 = new i_mx6_mmdc_pvt("MMDC2");
$end;
$create_component("GPC");
GPC = new i_mx6_gpc_pvt("GPC");
$end;
$create_component("PCIe_br");
PCIe_br = new AXI2GENERIC_br_pvt("PCIe_br");
$end;
$create_component("PCIe");
PCIe = new i_mx6_pcie_pvt("PCIe");
$end;
$create_component("SATA_br");
SATA_br = new AXI2AHP_br_pvt("SATA_br");
$end;
$create_component("SATA");
SATA = new i_mx6_sata_pvt("SATA");
$end;
$create_component("USB_PHY1");
USB_PHY1 = new i_mx6_usbphy_pvt("USB_PHY1");
$end;
$create_component("USB_PHY2");
USB_PHY2 = new i_mx6_usbphy_pvt("USB_PHY2");
$end;
$create_component("USB_PHY1_br");
USB_PHY1_br = new ip2apb_pvt("USB_PHY1_br");
$end;
$create_component("AUDMUX");
AUDMUX = new i_mx6_audmux_pvt("AUDMUX");
$end;
$create_component("USB_PHY2_br");
USB_PHY2_br = new ip2apb_pvt("USB_PHY2_br");
$end;
$create_component("HDMI_br");
HDMI_br = new hdmi_br_pvt("HDMI_br");
$end;
$create_component("HDMI");
HDMI = new i_mx6_hdmi_pvt("HDMI");
$end;
$create_component("SSI1");
SSI1 = new i_mx6_ssi_pvt("SSI1");
$end;
$create_component("SSI2");
SSI2 = new i_mx6_ssi_pvt("SSI2");
$end;
$create_component("SSI3");
SSI3 = new i_mx6_ssi_pvt("SSI3");
$end;
$create_component("FLASH");
FLASH = new SPI_FLASH_pvt("FLASH");
$end;
$create_component("USBNC");
USBNC = new USBNC_pvt("USBNC");
$end;
$create_component("IPU2");
IPU2 = new i_mx6_ipu_pvt("IPU2");
$end;
$create_component("IPU2_br");
IPU2_br = new IPU_br_pvt("IPU2_br");
$end;
$create_component("HOST2_br");
HOST2_br = new usb_br_pvt("HOST2_br");
$end;
$create_component("OTG_br");
OTG_br = new usb_br_pvt("OTG_br");
$end;
$create_component("HOST3_br");
HOST3_br = new usb_br_pvt("HOST3_br");
$end;
$create_component("AHB2APBH");
AHB2APBH = new i_mx6_AHB2APBH_pvt("AHB2APBH");
$end;
$create_component("APBH_BUS");
APBH_BUS = new apbh_bus_pvt("APBH_BUS");
$end;
$create_component("ASRC");
ASRC = new i_mx6_asrc_pvt("ASRC");
$end;
$bind("L2C_PL310->Master0","AXI_BUS->bus_slave0");
vista_bind(L2C_PL310->Master0, AXI_BUS->bus_slave0);
$end;
$bind("CORTEX_A9MP->master0","L2C_PL310->Slave0");
vista_bind(CORTEX_A9MP->master0, L2C_PL310->Slave0);
$end;
$bind("L2C_PL310->Master1","AXI_BUS->bus_slave1");
vista_bind(L2C_PL310->Master1, AXI_BUS->bus_slave1);
$end;
$bind("IP_BUS->bus_master0","uSDHC1->IP_Slave");
vista_bind(IP_BUS->bus_master0, uSDHC1->IP_Slave);
$end;
$bind("uSDHC4->uSDHC_irq","CORTEX_A9MP->irq_25");
vista_bind(uSDHC4->uSDHC_irq, CORTEX_A9MP->irq_25);
$end;
$bind("AXI_BUS->bus_master0","AXI2AHB->slave_1");
vista_bind(AXI_BUS->bus_master0, AXI2AHB->slave_1);
$end;
$bind("AHB_BUS->bus_master0","AHB2IP->slave_1");
vista_bind(AHB_BUS->bus_master0, AHB2IP->slave_1);
$end;
$bind("IP_BUS->bus_master1","uSDHC2->IP_Slave");
vista_bind(IP_BUS->bus_master1, uSDHC2->IP_Slave);
$end;
$bind("uSDHC3->uSDHC_irq","CORTEX_A9MP->irq_24");
vista_bind(uSDHC3->uSDHC_irq, CORTEX_A9MP->irq_24);
$end;
$bind("CORTEX_A9MP->master1","L2C_PL310->Slave1");
vista_bind(CORTEX_A9MP->master1, L2C_PL310->Slave1);
$end;
$bind("AXI2AHB->master_1","AHB_BUS->bus_slave0");
vista_bind(AXI2AHB->master_1, AHB_BUS->bus_slave0);
$end;
$bind("IP_BUS->bus_master2","uSDHC3->IP_Slave");
vista_bind(IP_BUS->bus_master2, uSDHC3->IP_Slave);
$end;
$bind("uSDHC2->uSDHC_irq","CORTEX_A9MP->irq_23");
vista_bind(uSDHC2->uSDHC_irq, CORTEX_A9MP->irq_23);
$end;
$bind("IP_BUS->bus_master3","uSDHC4->IP_Slave");
vista_bind(IP_BUS->bus_master3, uSDHC4->IP_Slave);
$end;
$bind("uSDHC1->uSDHC_irq","CORTEX_A9MP->irq_22");
vista_bind(uSDHC1->uSDHC_irq, CORTEX_A9MP->irq_22);
$end;
$bind("GPIO1->irq_15_0","CORTEX_A9MP->irq_66");
vista_bind(GPIO1->irq_15_0, CORTEX_A9MP->irq_66);
$end;
$bind("GPIO1->irq_31_16","CORTEX_A9MP->irq_67");
vista_bind(GPIO1->irq_31_16, CORTEX_A9MP->irq_67);
$end;
$bind("GPIO1->irq_6","CORTEX_A9MP->irq_59");
vista_bind(GPIO1->irq_6, CORTEX_A9MP->irq_59);
$end;
$bind("GPIO1->irq_7","CORTEX_A9MP->irq_58");
vista_bind(GPIO1->irq_7, CORTEX_A9MP->irq_58);
$end;
$bind("GPIO1->irq_1","CORTEX_A9MP->irq_64");
vista_bind(GPIO1->irq_1, CORTEX_A9MP->irq_64);
$end;
$bind("GPIO1->irq_4","CORTEX_A9MP->irq_61");
vista_bind(GPIO1->irq_4, CORTEX_A9MP->irq_61);
$end;
$bind("GPIO1->irq_0","CORTEX_A9MP->irq_65");
vista_bind(GPIO1->irq_0, CORTEX_A9MP->irq_65);
$end;
$bind("GPIO1->irq_2","CORTEX_A9MP->irq_63");
vista_bind(GPIO1->irq_2, CORTEX_A9MP->irq_63);
$end;
$bind("GPIO1->irq_3","CORTEX_A9MP->irq_62");
vista_bind(GPIO1->irq_3, CORTEX_A9MP->irq_62);
$end;
$bind("GPIO1->irq_5","CORTEX_A9MP->irq_60");
vista_bind(GPIO1->irq_5, CORTEX_A9MP->irq_60);
$end;
$bind("GPIO4->irq_15_0","CORTEX_A9MP->irq_72");
vista_bind(GPIO4->irq_15_0, CORTEX_A9MP->irq_72);
$end;
$bind("GPIO2->irq_15_0","CORTEX_A9MP->irq_68");
vista_bind(GPIO2->irq_15_0, CORTEX_A9MP->irq_68);
$end;
$bind("GPIO4->irq_31_16","CORTEX_A9MP->irq_73");
vista_bind(GPIO4->irq_31_16, CORTEX_A9MP->irq_73);
$end;
$bind("GPIO2->irq_31_16","CORTEX_A9MP->irq_69");
vista_bind(GPIO2->irq_31_16, CORTEX_A9MP->irq_69);
$end;
$bind("GPIO5->irq_15_0","CORTEX_A9MP->irq_74");
vista_bind(GPIO5->irq_15_0, CORTEX_A9MP->irq_74);
$end;
$bind("GPIO5->irq_31_16","CORTEX_A9MP->irq_75");
vista_bind(GPIO5->irq_31_16, CORTEX_A9MP->irq_75);
$end;
$bind("GPIO3->irq_15_0","CORTEX_A9MP->irq_70");
vista_bind(GPIO3->irq_15_0, CORTEX_A9MP->irq_70);
$end;
$bind("GPIO3->irq_31_16","CORTEX_A9MP->irq_71");
vista_bind(GPIO3->irq_31_16, CORTEX_A9MP->irq_71);
$end;
$bind("IP_BUS->bus_master6","GPIO2->IP_bus_interface");
vista_bind(IP_BUS->bus_master6, GPIO2->IP_bus_interface);
$end;
$bind("IP_BUS->bus_master8","GPIO4->IP_bus_interface");
vista_bind(IP_BUS->bus_master8, GPIO4->IP_bus_interface);
$end;
$bind("IP_BUS->bus_master7","GPIO3->IP_bus_interface");
vista_bind(IP_BUS->bus_master7, GPIO3->IP_bus_interface);
$end;
$bind("IP_BUS->bus_master4","GPIO1->IP_bus_interface");
vista_bind(IP_BUS->bus_master4, GPIO1->IP_bus_interface);
$end;
$bind("IP_BUS->bus_master5","GPIO5->IP_bus_interface");
vista_bind(IP_BUS->bus_master5, GPIO5->IP_bus_interface);
$end;
$bind("AHB2IP->master_1","IP_BUS->bus_slave0");
vista_bind(AHB2IP->master_1, IP_BUS->bus_slave0);
$end;
$bind("AXI_BUS->bus_master2","DDR_MEM->slave");
vista_bind(AXI_BUS->bus_master2, DDR_MEM->slave);
$end;
$bind("AXI_BUS->bus_master3","OCRAM->slave");
vista_bind(AXI_BUS->bus_master3, OCRAM->slave);
$end;
$bind("AXI_BUS->bus_master1","EXT_MEM->slave");
vista_bind(AXI_BUS->bus_master1, EXT_MEM->slave);
$end;
$bind("AHB_BUS->bus_master1","ROM->slave");
vista_bind(AHB_BUS->bus_master1, ROM->slave);
$end;
$bind("AXI_BUS->bus_master4","AXI2AHB->slave_2");
vista_bind(AXI_BUS->bus_master4, AXI2AHB->slave_2);
$end;
$bind("USB_OTG->dma_port","AXI_BUS->bus_slave3");
vista_bind(USB_OTG->dma_port, AXI_BUS->bus_slave3);
$end;
$bind("USB_HOST1->dma_port","AXI_BUS->bus_slave4");
vista_bind(USB_HOST1->dma_port, AXI_BUS->bus_slave4);
$end;
$bind("USB_OTG->irq","CORTEX_A9MP->irq_43");
vista_bind(USB_OTG->irq, CORTEX_A9MP->irq_43);
$end;
$bind("GPT->irq","CORTEX_A9MP->irq_55");
vista_bind(GPT->irq, CORTEX_A9MP->irq_55);
$end;
$bind("IP_BUS->bus_master12","GPT->slave");
vista_bind(IP_BUS->bus_master12, GPT->slave);
$end;
$bind("WDOG2->irq","CORTEX_A9MP->irq_81");
vista_bind(WDOG2->irq, CORTEX_A9MP->irq_81);
$end;
$bind("IP_BUS->bus_master13","WDOG1->Bus");
vista_bind(IP_BUS->bus_master13, WDOG1->Bus);
$end;
$bind("WDOG1->irq","CORTEX_A9MP->irq_80");
vista_bind(WDOG1->irq, CORTEX_A9MP->irq_80);
$end;
$bind("IP_BUS->bus_master14","WDOG2->Bus");
vista_bind(IP_BUS->bus_master14, WDOG2->Bus);
$end;
$bind("IP_BUS->bus_master20","UART5->IP_bus_interface");
vista_bind(IP_BUS->bus_master20, UART5->IP_bus_interface);
$end;
$bind("IP_BUS->bus_master18","UART3->IP_bus_interface");
vista_bind(IP_BUS->bus_master18, UART3->IP_bus_interface);
$end;
$bind("IP_BUS->bus_master16","UART1->IP_bus_interface");
vista_bind(IP_BUS->bus_master16, UART1->IP_bus_interface);
$end;
$bind("IP_BUS->bus_master19","UART4->IP_bus_interface");
vista_bind(IP_BUS->bus_master19, UART4->IP_bus_interface);
$end;
$bind("IP_BUS->bus_master17","UART2->IP_bus_interface");
vista_bind(IP_BUS->bus_master17, UART2->IP_bus_interface);
$end;
$bind("UART1->irq","CORTEX_A9MP->irq_26");
vista_bind(UART1->irq, CORTEX_A9MP->irq_26);
$end;
$bind("UART5->irq","CORTEX_A9MP->irq_30");
vista_bind(UART5->irq, CORTEX_A9MP->irq_30);
$end;
$bind("UART2->irq","CORTEX_A9MP->irq_27");
vista_bind(UART2->irq, CORTEX_A9MP->irq_27);
$end;
$bind("UART3->irq","CORTEX_A9MP->irq_28");
vista_bind(UART3->irq, CORTEX_A9MP->irq_28);
$end;
$bind("UART4->irq","CORTEX_A9MP->irq_29");
vista_bind(UART4->irq, CORTEX_A9MP->irq_29);
$end;
$bind("I2C1->irq","CORTEX_A9MP->irq_36");
vista_bind(I2C1->irq, CORTEX_A9MP->irq_36);
$end;
$bind("IP_BUS->bus_master21","I2C1->Bus");
vista_bind(IP_BUS->bus_master21, I2C1->Bus);
$end;
$bind("I2C3->irq","CORTEX_A9MP->irq_38");
vista_bind(I2C3->irq, CORTEX_A9MP->irq_38);
$end;
$bind("IP_BUS->bus_master22","I2C2->Bus");
vista_bind(IP_BUS->bus_master22, I2C2->Bus);
$end;
$bind("I2C2->irq","CORTEX_A9MP->irq_37");
vista_bind(I2C2->irq, CORTEX_A9MP->irq_37);
$end;
$bind("IP_BUS->bus_master23","I2C3->Bus");
vista_bind(IP_BUS->bus_master23, I2C3->Bus);
$end;
$bind("SDMA->BDMA_Master","AHB_BUS->bus_slave6");
vista_bind(SDMA->BDMA_Master, AHB_BUS->bus_slave6);
$end;
$bind("SDMA->PDMA_Master","AHB_BUS->bus_slave5");
vista_bind(SDMA->PDMA_Master, AHB_BUS->bus_slave5);
$end;
$bind("SDMA->Periph_Master","IP_BUS->bus_slave1");
vista_bind(SDMA->Periph_Master, IP_BUS->bus_slave1);
$end;
$bind("IP_BUS->bus_master24","SDMA->IP_Slave");
vista_bind(IP_BUS->bus_master24, SDMA->IP_Slave);
$end;
$bind("SDMA->IRQ","CORTEX_A9MP->irq_2");
vista_bind(SDMA->IRQ, CORTEX_A9MP->irq_2);
$end;
$bind("IP_BUS->bus_master25","SPDIF->Bus");
vista_bind(IP_BUS->bus_master25, SPDIF->Bus);
$end;
$bind("SPDIF->SPDIFOUT","SPDIF->SPDIFIN");
vista_bind(SPDIF->SPDIFOUT, SPDIF->SPDIFIN);
$end;
$bind("SPDIF->irq","CORTEX_A9MP->irq_52");
vista_bind(SPDIF->irq, CORTEX_A9MP->irq_52);
$end;
$bind("IP_BUS->bus_master27","EPIT1->SLAVE");
vista_bind(IP_BUS->bus_master27, EPIT1->SLAVE);
$end;
$bind("IP_BUS->bus_master28","EPIT2->SLAVE");
vista_bind(IP_BUS->bus_master28, EPIT2->SLAVE);
$end;
$bind("EPIT1->INTR","CORTEX_A9MP->irq_56");
vista_bind(EPIT1->INTR, CORTEX_A9MP->irq_56);
$end;
$bind("EPIT2->INTR","CORTEX_A9MP->irq_57");
vista_bind(EPIT2->INTR, CORTEX_A9MP->irq_57);
$end;
$bind("sd_br1->master","AXI_BUS->bus_slave9");
vista_bind(sd_br1->master, AXI_BUS->bus_slave9);
$end;
$bind("uSDHC4->AHB_Master","sd_br4->slave");
vista_bind(uSDHC4->AHB_Master, sd_br4->slave);
$end;
$bind("uSDHC3->AHB_Master","sd_br3->slave");
vista_bind(uSDHC3->AHB_Master, sd_br3->slave);
$end;
$bind("sd_br4->master","AXI_BUS->bus_slave6");
vista_bind(sd_br4->master, AXI_BUS->bus_slave6);
$end;
$bind("uSDHC2->AHB_Master","sd_br2->slave");
vista_bind(uSDHC2->AHB_Master, sd_br2->slave);
$end;
$bind("uSDHC1->AHB_Master","sd_br1->slave");
vista_bind(uSDHC1->AHB_Master, sd_br1->slave);
$end;
$bind("sd_br3->master","AXI_BUS->bus_slave7");
vista_bind(sd_br3->master, AXI_BUS->bus_slave7);
$end;
$bind("sd_br2->master","AXI_BUS->bus_slave8");
vista_bind(sd_br2->master, AXI_BUS->bus_slave8);
$end;
$bind("IP_BUS->bus_master32","IOMUXC->IOMUX_Slave");
vista_bind(IP_BUS->bus_master32, IOMUXC->IOMUX_Slave);
$end;
$bind("IOMUXC->irq","CORTEX_A9MP->irq_0");
vista_bind(IOMUXC->irq, CORTEX_A9MP->irq_0);
$end;
$bind("IP_BUS->bus_master29","CCM->Slave");
vista_bind(IP_BUS->bus_master29, CCM->Slave);
$end;
$bind("GPIO7->irq_15_0","CORTEX_A9MP->irq_78");
vista_bind(GPIO7->irq_15_0, CORTEX_A9MP->irq_78);
$end;
$bind("USB_HOST3->dma_port","AXI_BUS->bus_slave10");
vista_bind(USB_HOST3->dma_port, AXI_BUS->bus_slave10);
$end;
$bind("USB_HOST1->irq","CORTEX_A9MP->irq_40");
vista_bind(USB_HOST1->irq, CORTEX_A9MP->irq_40);
$end;
$bind("USB_HOST2->dma_port","AXI_BUS->bus_slave2");
vista_bind(USB_HOST2->dma_port, AXI_BUS->bus_slave2);
$end;
$bind("IP_BUS->bus_master31","GPIO7->IP_bus_interface");
vista_bind(IP_BUS->bus_master31, GPIO7->IP_bus_interface);
$end;
$bind("USB_HOST3->irq","CORTEX_A9MP->irq_42");
vista_bind(USB_HOST3->irq, CORTEX_A9MP->irq_42);
$end;
$bind("GPIO6->irq_31_16","CORTEX_A9MP->irq_77");
vista_bind(GPIO6->irq_31_16, CORTEX_A9MP->irq_77);
$end;
$bind("CCM->irq1","CORTEX_A9MP->irq_87");
vista_bind(CCM->irq1, CORTEX_A9MP->irq_87);
$end;
$bind("GPIO7->irq_31_16","CORTEX_A9MP->irq_79");
vista_bind(GPIO7->irq_31_16, CORTEX_A9MP->irq_79);
$end;
$bind("USB_HOST2->irq","CORTEX_A9MP->irq_41");
vista_bind(USB_HOST2->irq, CORTEX_A9MP->irq_41);
$end;
$bind("GPIO6->irq_15_0","CORTEX_A9MP->irq_76");
vista_bind(GPIO6->irq_15_0, CORTEX_A9MP->irq_76);
$end;
$bind("CCM->irq2","CORTEX_A9MP->irq_88");
vista_bind(CCM->irq2, CORTEX_A9MP->irq_88);
$end;
$bind("IP_BUS->bus_master30","GPIO6->IP_bus_interface");
vista_bind(IP_BUS->bus_master30, GPIO6->IP_bus_interface);
$end;
$bind("ENET->irq","CORTEX_A9MP->irq_118");
vista_bind(ENET->irq, CORTEX_A9MP->irq_118);
$end;
$bind("IP_BUS->bus_master15","ENET->SIF");
vista_bind(IP_BUS->bus_master15, ENET->SIF);
$end;
$bind("enet_br->master","AXI_BUS->bus_slave11");
vista_bind(enet_br->master, AXI_BUS->bus_slave11);
$end;
$bind("ENET->Master","enet_br->slave");
vista_bind(ENET->Master, enet_br->slave);
$end;
$bind("ENET->phy_gpio","GPIO1->gpio_in_28");
vista_bind(ENET->phy_gpio, GPIO1->gpio_in_28);
$end;
$bind("IPU1->sync_irq","CORTEX_A9MP->irq_6");
vista_bind(IPU1->sync_irq, CORTEX_A9MP->irq_6);
$end;
$bind("IP_BUS->bus_master43","ECSPI5->Slave");
vista_bind(IP_BUS->bus_master43, ECSPI5->Slave);
$end;
$bind("ECSPI4->IRQ","CORTEX_A9MP->irq_34");
vista_bind(ECSPI4->IRQ, CORTEX_A9MP->irq_34);
$end;
$bind("ECSPI2->IRQ","CORTEX_A9MP->irq_32");
vista_bind(ECSPI2->IRQ, CORTEX_A9MP->irq_32);
$end;
$bind("IP_BUS->bus_master42","ECSPI4->Slave");
vista_bind(IP_BUS->bus_master42, ECSPI4->Slave);
$end;
$bind("IP_BUS->bus_master41","ECSPI3->Slave");
vista_bind(IP_BUS->bus_master41, ECSPI3->Slave);
$end;
$bind("IP_BUS->bus_master39","ECSPI1->Slave");
vista_bind(IP_BUS->bus_master39, ECSPI1->Slave);
$end;
$bind("IP_BUS->bus_master40","ECSPI2->Slave");
vista_bind(IP_BUS->bus_master40, ECSPI2->Slave);
$end;
$bind("IPU1->err_irq","CORTEX_A9MP->irq_5");
vista_bind(IPU1->err_irq, CORTEX_A9MP->irq_5);
$end;
$bind("ECSPI5->IRQ","CORTEX_A9MP->irq_35");
vista_bind(ECSPI5->IRQ, CORTEX_A9MP->irq_35);
$end;
$bind("ECSPI3->IRQ","CORTEX_A9MP->irq_33");
vista_bind(ECSPI3->IRQ, CORTEX_A9MP->irq_33);
$end;
$bind("ECSPI1->IRQ","CORTEX_A9MP->irq_31");
vista_bind(ECSPI1->IRQ, CORTEX_A9MP->irq_31);
$end;
$bind("I2C1->i2c_bus","EEPROM3->Slave");
vista_bind(I2C1->i2c_bus, EEPROM3->Slave);
$end;
$bind("I2C2->i2c_bus","EEPROM2->Slave");
vista_bind(I2C2->i2c_bus, EEPROM2->Slave);
$end;
$bind("IPU1->Memory","AXI_BUS->bus_slave5");
vista_bind(IPU1->Memory, AXI_BUS->bus_slave5);
$end;
$bind("IPU1_br->master_1","IPU1->slave");
vista_bind(IPU1_br->master_1, IPU1->slave);
$end;
$bind("AXI_BUS->bus_master5","IPU1_br->slave_1");
vista_bind(AXI_BUS->bus_master5, IPU1_br->slave_1);
$end;
$bind("I2C3->i2c_bus","IPU1->touch_if");
vista_bind(I2C3->i2c_bus, IPU1->touch_if);
$end;
$bind("SRC->n_reset_1","CORTEX_A9MP->n_reset_1");
vista_bind(SRC->n_reset_1, CORTEX_A9MP->n_reset_1);
$end;
$bind("IOMUXC->sdcard_detect","GPIO7->gpio_in_0");
vista_bind(IOMUXC->sdcard_detect, GPIO7->gpio_in_0);
$end;
$bind("IPU1->touch_irq","GPIO1->gpio_in_9");
vista_bind(IPU1->touch_irq, GPIO1->gpio_in_9);
$end;
$bind("IP_BUS->bus_master34","SRC->host");
vista_bind(IP_BUS->bus_master34, SRC->host);
$end;
$bind("PWM2->IRQ","CORTEX_A9MP->irq_84");
vista_bind(PWM2->IRQ, CORTEX_A9MP->irq_84);
$end;
$bind("PWM3->IRQ","CORTEX_A9MP->irq_85");
vista_bind(PWM3->IRQ, CORTEX_A9MP->irq_85);
$end;
$bind("IP_BUS->bus_master35","PWM1->SLAVE");
vista_bind(IP_BUS->bus_master35, PWM1->SLAVE);
$end;
$bind("PWM4->IRQ","CORTEX_A9MP->irq_86");
vista_bind(PWM4->IRQ, CORTEX_A9MP->irq_86);
$end;
$bind("IP_BUS->bus_master36","PWM2->SLAVE");
vista_bind(IP_BUS->bus_master36, PWM2->SLAVE);
$end;
$bind("IP_BUS->bus_master37","PWM3->SLAVE");
vista_bind(IP_BUS->bus_master37, PWM3->SLAVE);
$end;
$bind("IP_BUS->bus_master38","PWM4->SLAVE");
vista_bind(IP_BUS->bus_master38, PWM4->SLAVE);
$end;
$bind("IP_BUS->bus_master44","OCOTP_CTRL->host");
vista_bind(IP_BUS->bus_master44, OCOTP_CTRL->host);
$end;
$bind("SNVS->irq1","CORTEX_A9MP->irq_4");
vista_bind(SNVS->irq1, CORTEX_A9MP->irq_4);
$end;
$bind("IP_BUS->bus_master49","SNVS->slave");
vista_bind(IP_BUS->bus_master49, SNVS->slave);
$end;
$bind("IP_BUS->bus_master47","MMDC1->IP_BUS");
vista_bind(IP_BUS->bus_master47, MMDC1->IP_BUS);
$end;
$bind("GPC->irq","CORTEX_A9MP->irq_89");
vista_bind(GPC->irq, CORTEX_A9MP->irq_89);
$end;
$bind("IP_BUS->bus_master46","GPC->IP_BUS");
vista_bind(IP_BUS->bus_master46, GPC->IP_BUS);
$end;
$bind("IP_BUS->bus_master48","MMDC2->IP_BUS");
vista_bind(IP_BUS->bus_master48, MMDC2->IP_BUS);
$end;
$bind("SNVS->irq3","CORTEX_A9MP->irq_20");
vista_bind(SNVS->irq3, CORTEX_A9MP->irq_20);
$end;
$bind("SNVS->irq2","CORTEX_A9MP->irq_19");
vista_bind(SNVS->irq2, CORTEX_A9MP->irq_19);
$end;
$bind("SATA_br->master_1","SATA->AHB_Slave");
vista_bind(SATA_br->master_1, SATA->AHB_Slave);
$end;
$bind("USB_PHY2_br->master_1","USB_PHY2->APB");
vista_bind(USB_PHY2_br->master_1, USB_PHY2->APB);
$end;
$bind("IP_BUS->bus_master52","AUDMUX->Slave");
vista_bind(IP_BUS->bus_master52, AUDMUX->Slave);
$end;
$bind("PCIe_br->master_1","PCIe->Slave");
vista_bind(PCIe_br->master_1, PCIe->Slave);
$end;
$bind("USB_PHY1_br->master_1","USB_PHY1->APB");
vista_bind(USB_PHY1_br->master_1, USB_PHY1->APB);
$end;
$bind("USB_PHY1->irq","CORTEX_A9MP->irq_44");
vista_bind(USB_PHY1->irq, CORTEX_A9MP->irq_44);
$end;
$bind("IP_BUS->bus_master51","USB_PHY1_br->slave_1");
vista_bind(IP_BUS->bus_master51, USB_PHY1_br->slave_1);
$end;
$bind("PCIe->irq1","CORTEX_A9MP->irq_120");
vista_bind(PCIe->irq1, CORTEX_A9MP->irq_120);
$end;
$bind("SATA->irq","CORTEX_A9MP->irq_39");
vista_bind(SATA->irq, CORTEX_A9MP->irq_39);
$end;
$bind("AXI_BUS->bus_master6","SATA_br->slave_1");
vista_bind(AXI_BUS->bus_master6, SATA_br->slave_1);
$end;
$bind("PCIe->irq2","CORTEX_A9MP->irq_121");
vista_bind(PCIe->irq2, CORTEX_A9MP->irq_121);
$end;
$bind("IP_BUS->bus_master50","USB_PHY2_br->slave_1");
vista_bind(IP_BUS->bus_master50, USB_PHY2_br->slave_1);
$end;
$bind("USB_PHY2->irq","CORTEX_A9MP->irq_45");
vista_bind(USB_PHY2->irq, CORTEX_A9MP->irq_45);
$end;
$bind("AXI_BUS->bus_master7","PCIe_br->slave_1");
vista_bind(AXI_BUS->bus_master7, PCIe_br->slave_1);
$end;
$bind("PCIe->irq3","CORTEX_A9MP->irq_122");
vista_bind(PCIe->irq3, CORTEX_A9MP->irq_122);
$end;
$bind("PCIe->irq4","CORTEX_A9MP->irq_123");
vista_bind(PCIe->irq4, CORTEX_A9MP->irq_123);
$end;
$bind("IP_BUS->bus_master55","SSI3->IP_BUS");
vista_bind(IP_BUS->bus_master55, SSI3->IP_BUS);
$end;
$bind("SSI3->irq","CORTEX_A9MP->irq_48");
vista_bind(SSI3->irq, CORTEX_A9MP->irq_48);
$end;
$bind("HDMI->irq1","CORTEX_A9MP->irq_115");
vista_bind(HDMI->irq1, CORTEX_A9MP->irq_115);
$end;
$bind("HDMI->irq2","CORTEX_A9MP->irq_116");
vista_bind(HDMI->irq2, CORTEX_A9MP->irq_116);
$end;
$bind("IP_BUS->bus_master53","SSI1->IP_BUS");
vista_bind(IP_BUS->bus_master53, SSI1->IP_BUS);
$end;
$bind("IP_BUS->bus_master54","SSI2->IP_BUS");
vista_bind(IP_BUS->bus_master54, SSI2->IP_BUS);
$end;
$bind("SSI1->irq","CORTEX_A9MP->irq_46");
vista_bind(SSI1->irq, CORTEX_A9MP->irq_46);
$end;
$bind("SSI2->irq","CORTEX_A9MP->irq_47");
vista_bind(SSI2->irq, CORTEX_A9MP->irq_47);
$end;
$bind("AXI_BUS->bus_master8","HDMI_br->slave_1");
vista_bind(AXI_BUS->bus_master8, HDMI_br->slave_1);
$end;
$bind("HDMI_br->master_1","HDMI->AHB_slave");
vista_bind(HDMI_br->master_1, HDMI->AHB_slave);
$end;
$bind("SRC->n_reset_3","CORTEX_A9MP->n_reset_3");
vista_bind(SRC->n_reset_3, CORTEX_A9MP->n_reset_3);
$end;
$bind("SRC->n_reset_2","CORTEX_A9MP->n_reset_2");
vista_bind(SRC->n_reset_2, CORTEX_A9MP->n_reset_2);
$end;
$bind("ECSPI5->Data_OUT1","ECSPI5->Data_IN1");
vista_bind(ECSPI5->Data_OUT1, ECSPI5->Data_IN1);
$end;
$bind("ECSPI3->Data_OUT0","ECSPI3->Data_IN0");
vista_bind(ECSPI3->Data_OUT0, ECSPI3->Data_IN0);
$end;
$bind("ECSPI5->Data_OUT0","ECSPI5->Data_IN0");
vista_bind(ECSPI5->Data_OUT0, ECSPI5->Data_IN0);
$end;
$bind("ECSPI2->Data_OUT3","ECSPI2->Data_IN3");
vista_bind(ECSPI2->Data_OUT3, ECSPI2->Data_IN3);
$end;
$bind("ECSPI4->Data_OUT3","ECSPI4->Data_IN3");
vista_bind(ECSPI4->Data_OUT3, ECSPI4->Data_IN3);
$end;
$bind("ECSPI2->Data_OUT2","ECSPI2->Data_IN2");
vista_bind(ECSPI2->Data_OUT2, ECSPI2->Data_IN2);
$end;
$bind("ECSPI4->Data_OUT2","ECSPI4->Data_IN2");
vista_bind(ECSPI4->Data_OUT2, ECSPI4->Data_IN2);
$end;
$bind("ECSPI2->Data_OUT1","ECSPI2->Data_IN1");
vista_bind(ECSPI2->Data_OUT1, ECSPI2->Data_IN1);
$end;
$bind("ECSPI4->Data_OUT1","ECSPI4->Data_IN1");
vista_bind(ECSPI4->Data_OUT1, ECSPI4->Data_IN1);
$end;
$bind("ECSPI2->Data_OUT0","ECSPI2->Data_IN0");
vista_bind(ECSPI2->Data_OUT0, ECSPI2->Data_IN0);
$end;
$bind("ECSPI4->Data_OUT0","ECSPI4->Data_IN0");
vista_bind(ECSPI4->Data_OUT0, ECSPI4->Data_IN0);
$end;
$bind("ECSPI1->Data_OUT3","ECSPI1->Data_IN3");
vista_bind(ECSPI1->Data_OUT3, ECSPI1->Data_IN3);
$end;
$bind("ECSPI3->Data_OUT3","ECSPI3->Data_IN3");
vista_bind(ECSPI3->Data_OUT3, ECSPI3->Data_IN3);
$end;
$bind("ECSPI1->Data_OUT2","ECSPI1->Data_IN2");
vista_bind(ECSPI1->Data_OUT2, ECSPI1->Data_IN2);
$end;
$bind("ECSPI5->Data_OUT3","ECSPI5->Data_IN3");
vista_bind(ECSPI5->Data_OUT3, ECSPI5->Data_IN3);
$end;
$bind("ECSPI3->Data_OUT2","ECSPI3->Data_IN2");
vista_bind(ECSPI3->Data_OUT2, ECSPI3->Data_IN2);
$end;
$bind("ECSPI1->Data_OUT1","ECSPI1->Data_IN1");
vista_bind(ECSPI1->Data_OUT1, ECSPI1->Data_IN1);
$end;
$bind("ECSPI5->Data_OUT2","ECSPI5->Data_IN2");
vista_bind(ECSPI5->Data_OUT2, ECSPI5->Data_IN2);
$end;
$bind("ECSPI3->Data_OUT1","ECSPI3->Data_IN1");
vista_bind(ECSPI3->Data_OUT1, ECSPI3->Data_IN1);
$end;
$bind("ECSPI1->Data_OUT0","FLASH->Slave");
vista_bind(ECSPI1->Data_OUT0, FLASH->Slave);
$end;
$bind("IP_BUS->bus_master56","USBNC->slave");
vista_bind(IP_BUS->bus_master56, USBNC->slave);
$end;
$bind("IPU2->sync_irq","CORTEX_A9MP->irq_8");
vista_bind(IPU2->sync_irq, CORTEX_A9MP->irq_8);
$end;
$bind("IPU2->Memory","AXI_BUS->bus_slave12");
vista_bind(IPU2->Memory, AXI_BUS->bus_slave12);
$end;
$bind("IPU2->err_irq","CORTEX_A9MP->irq_7");
vista_bind(IPU2->err_irq, CORTEX_A9MP->irq_7);
$end;
$bind("IPU2_br->master_1","IPU2->slave");
vista_bind(IPU2_br->master_1, IPU2->slave);
$end;
$bind("AXI_BUS->bus_master9","IPU2_br->slave_1");
vista_bind(AXI_BUS->bus_master9, IPU2_br->slave_1);
$end;
$bind("HOST3_br->master","USB_HOST3->host");
vista_bind(HOST3_br->master, USB_HOST3->host);
$end;
$bind("HOST2_br->master","USB_HOST2->host");
vista_bind(HOST2_br->master, USB_HOST2->host);
$end;
$bind("IP_BUS->bus_master11","HOST2_br->slave");
vista_bind(IP_BUS->bus_master11, HOST2_br->slave);
$end;
$bind("IP_BUS->bus_master10","OTG_br->slave");
vista_bind(IP_BUS->bus_master10, OTG_br->slave);
$end;
$bind("IP_BUS->bus_master33","HOST3_br->slave");
vista_bind(IP_BUS->bus_master33, HOST3_br->slave);
$end;
$bind("OTG_br->master","USB_OTG->host");
vista_bind(OTG_br->master, USB_OTG->host);
$end;
$bind("AHB2APBH->AHB_Master","AHB_BUS->bus_slave4");
vista_bind(AHB2APBH->AHB_Master, AHB_BUS->bus_slave4);
$end;
$bind("AHB2APBH->APB_Master","APBH_BUS->bus_slave0");
vista_bind(AHB2APBH->APB_Master, APBH_BUS->bus_slave0);
$end;
$bind("AHB_BUS->bus_master2","AHB2APBH->AHB_Slave");
vista_bind(AHB_BUS->bus_master2, AHB2APBH->AHB_Slave);
$end;
$bind("IP_BUS->bus_master57","ASRC->Slave");
vista_bind(IP_BUS->bus_master57, ASRC->Slave);
$end;
$bind("ASRC->IRQ","CORTEX_A9MP->irq_50");
vista_bind(ASRC->IRQ, CORTEX_A9MP->irq_50);
$end;
$bind("IP_BUS->bus_master9","USB_HOST1->host");
vista_bind(IP_BUS->bus_master9, USB_HOST1->host);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "iMX6_schematics";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~i_mx6sl_top() {
    $destructor_begin;
$destruct_component("AHB_BUS");
delete AHB_BUS; AHB_BUS = 0;
$end;
$destruct_component("IP_BUS");
delete IP_BUS; IP_BUS = 0;
$end;
$destruct_component("uSDHC1");
delete uSDHC1; uSDHC1 = 0;
$end;
$destruct_component("uSDHC4");
delete uSDHC4; uSDHC4 = 0;
$end;
$destruct_component("L2C_PL310");
delete L2C_PL310; L2C_PL310 = 0;
$end;
$destruct_component("AHB2IP");
delete AHB2IP; AHB2IP = 0;
$end;
$destruct_component("uSDHC3");
delete uSDHC3; uSDHC3 = 0;
$end;
$destruct_component("AXI2AHB");
delete AXI2AHB; AXI2AHB = 0;
$end;
$destruct_component("CORTEX_A9MP");
delete CORTEX_A9MP; CORTEX_A9MP = 0;
$end;
$destruct_component("AXI_BUS");
delete AXI_BUS; AXI_BUS = 0;
$end;
$destruct_component("uSDHC2");
delete uSDHC2; uSDHC2 = 0;
$end;
$destruct_component("GPIO4");
delete GPIO4; GPIO4 = 0;
$end;
$destruct_component("GPIO3");
delete GPIO3; GPIO3 = 0;
$end;
$destruct_component("GPIO2");
delete GPIO2; GPIO2 = 0;
$end;
$destruct_component("GPIO1");
delete GPIO1; GPIO1 = 0;
$end;
$destruct_component("GPIO5");
delete GPIO5; GPIO5 = 0;
$end;
$destruct_component("OCRAM");
delete OCRAM; OCRAM = 0;
$end;
$destruct_component("ROM");
delete ROM; ROM = 0;
$end;
$destruct_component("DDR_MEM");
delete DDR_MEM; DDR_MEM = 0;
$end;
$destruct_component("EXT_MEM");
delete EXT_MEM; EXT_MEM = 0;
$end;
$destruct_component("USB_OTG");
delete USB_OTG; USB_OTG = 0;
$end;
$destruct_component("USB_HOST1");
delete USB_HOST1; USB_HOST1 = 0;
$end;
$destruct_component("GPT");
delete GPT; GPT = 0;
$end;
$destruct_component("WDOG2");
delete WDOG2; WDOG2 = 0;
$end;
$destruct_component("WDOG1");
delete WDOG1; WDOG1 = 0;
$end;
$destruct_component("UART5");
delete UART5; UART5 = 0;
$end;
$destruct_component("UART1");
delete UART1; UART1 = 0;
$end;
$destruct_component("UART2");
delete UART2; UART2 = 0;
$end;
$destruct_component("UART3");
delete UART3; UART3 = 0;
$end;
$destruct_component("UART4");
delete UART4; UART4 = 0;
$end;
$destruct_component("I2C3");
delete I2C3; I2C3 = 0;
$end;
$destruct_component("I2C2");
delete I2C2; I2C2 = 0;
$end;
$destruct_component("I2C1");
delete I2C1; I2C1 = 0;
$end;
$destruct_component("SDMA");
delete SDMA; SDMA = 0;
$end;
$destruct_component("SPDIF");
delete SPDIF; SPDIF = 0;
$end;
$destruct_component("EPIT1");
delete EPIT1; EPIT1 = 0;
$end;
$destruct_component("EPIT2");
delete EPIT2; EPIT2 = 0;
$end;
$destruct_component("CCM");
delete CCM; CCM = 0;
$end;
$destruct_component("sd_br1");
delete sd_br1; sd_br1 = 0;
$end;
$destruct_component("sd_br2");
delete sd_br2; sd_br2 = 0;
$end;
$destruct_component("sd_br3");
delete sd_br3; sd_br3 = 0;
$end;
$destruct_component("sd_br4");
delete sd_br4; sd_br4 = 0;
$end;
$destruct_component("IOMUXC");
delete IOMUXC; IOMUXC = 0;
$end;
$destruct_component("GPIO6");
delete GPIO6; GPIO6 = 0;
$end;
$destruct_component("GPIO7");
delete GPIO7; GPIO7 = 0;
$end;
$destruct_component("USB_HOST2");
delete USB_HOST2; USB_HOST2 = 0;
$end;
$destruct_component("USB_HOST3");
delete USB_HOST3; USB_HOST3 = 0;
$end;
$destruct_component("ENET");
delete ENET; ENET = 0;
$end;
$destruct_component("enet_br");
delete enet_br; enet_br = 0;
$end;
$destruct_component("PWM2");
delete PWM2; PWM2 = 0;
$end;
$destruct_component("PWM4");
delete PWM4; PWM4 = 0;
$end;
$destruct_component("PWM1");
delete PWM1; PWM1 = 0;
$end;
$destruct_component("PWM3");
delete PWM3; PWM3 = 0;
$end;
$destruct_component("ECSPI2");
delete ECSPI2; ECSPI2 = 0;
$end;
$destruct_component("SRC");
delete SRC; SRC = 0;
$end;
$destruct_component("ECSPI5");
delete ECSPI5; ECSPI5 = 0;
$end;
$destruct_component("ECSPI3");
delete ECSPI3; ECSPI3 = 0;
$end;
$destruct_component("IPU1");
delete IPU1; IPU1 = 0;
$end;
$destruct_component("ECSPI1");
delete ECSPI1; ECSPI1 = 0;
$end;
$destruct_component("ECSPI4");
delete ECSPI4; ECSPI4 = 0;
$end;
$destruct_component("EEPROM2");
delete EEPROM2; EEPROM2 = 0;
$end;
$destruct_component("EEPROM3");
delete EEPROM3; EEPROM3 = 0;
$end;
$destruct_component("IPU1_br");
delete IPU1_br; IPU1_br = 0;
$end;
$destruct_component("OCOTP_CTRL");
delete OCOTP_CTRL; OCOTP_CTRL = 0;
$end;
$destruct_component("MMDC1");
delete MMDC1; MMDC1 = 0;
$end;
$destruct_component("SNVS");
delete SNVS; SNVS = 0;
$end;
$destruct_component("MMDC2");
delete MMDC2; MMDC2 = 0;
$end;
$destruct_component("GPC");
delete GPC; GPC = 0;
$end;
$destruct_component("PCIe_br");
delete PCIe_br; PCIe_br = 0;
$end;
$destruct_component("PCIe");
delete PCIe; PCIe = 0;
$end;
$destruct_component("SATA_br");
delete SATA_br; SATA_br = 0;
$end;
$destruct_component("SATA");
delete SATA; SATA = 0;
$end;
$destruct_component("USB_PHY1");
delete USB_PHY1; USB_PHY1 = 0;
$end;
$destruct_component("USB_PHY2");
delete USB_PHY2; USB_PHY2 = 0;
$end;
$destruct_component("USB_PHY1_br");
delete USB_PHY1_br; USB_PHY1_br = 0;
$end;
$destruct_component("AUDMUX");
delete AUDMUX; AUDMUX = 0;
$end;
$destruct_component("USB_PHY2_br");
delete USB_PHY2_br; USB_PHY2_br = 0;
$end;
$destruct_component("HDMI_br");
delete HDMI_br; HDMI_br = 0;
$end;
$destruct_component("HDMI");
delete HDMI; HDMI = 0;
$end;
$destruct_component("SSI1");
delete SSI1; SSI1 = 0;
$end;
$destruct_component("SSI2");
delete SSI2; SSI2 = 0;
$end;
$destruct_component("SSI3");
delete SSI3; SSI3 = 0;
$end;
$destruct_component("FLASH");
delete FLASH; FLASH = 0;
$end;
$destruct_component("USBNC");
delete USBNC; USBNC = 0;
$end;
$destruct_component("IPU2");
delete IPU2; IPU2 = 0;
$end;
$destruct_component("IPU2_br");
delete IPU2_br; IPU2_br = 0;
$end;
$destruct_component("HOST2_br");
delete HOST2_br; HOST2_br = 0;
$end;
$destruct_component("OTG_br");
delete OTG_br; OTG_br = 0;
$end;
$destruct_component("HOST3_br");
delete HOST3_br; HOST3_br = 0;
$end;
$destruct_component("AHB2APBH");
delete AHB2APBH; AHB2APBH = 0;
$end;
$destruct_component("APBH_BUS");
delete APBH_BUS; APBH_BUS = 0;
$end;
$destruct_component("ASRC");
delete ASRC; ASRC = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("AHB_BUS");
ahb_bus_pvt *AHB_BUS;
$end;
$component("IP_BUS");
ip_bus_pvt *IP_BUS;
$end;
$component("uSDHC1");
i_mx6_usdhc_pvt *uSDHC1;
$end;
$component("uSDHC4");
i_mx6_usdhc_pvt *uSDHC4;
$end;
$component("L2C_PL310");
PL310_pvt *L2C_PL310;
$end;
$component("AHB2IP");
ahb2ip_pvt *AHB2IP;
$end;
$component("uSDHC3");
i_mx6_usdhc_pvt *uSDHC3;
$end;
$component("AXI2AHB");
axi2ahb_pvt *AXI2AHB;
$end;
$component("CORTEX_A9MP");
Cortex_A9MP_pvt *CORTEX_A9MP;
$end;
$component("AXI_BUS");
axi_bus_pvt *AXI_BUS;
$end;
$component("uSDHC2");
i_mx6_usdhc_pvt *uSDHC2;
$end;
$component("GPIO4");
i_mx6_gpio_pvt *GPIO4;
$end;
$component("GPIO3");
i_mx6_gpio_pvt *GPIO3;
$end;
$component("GPIO2");
i_mx6_gpio_pvt *GPIO2;
$end;
$component("GPIO1");
i_mx6_gpio_pvt *GPIO1;
$end;
$component("GPIO5");
i_mx6_gpio_pvt *GPIO5;
$end;
$component("OCRAM");
ocram_pvt *OCRAM;
$end;
$component("ROM");
rom_pvt *ROM;
$end;
$component("DDR_MEM");
ddr_memory_pvt *DDR_MEM;
$end;
$component("EXT_MEM");
ext_memory_pvt *EXT_MEM;
$end;
$component("USB_OTG");
usb_otg_pvt *USB_OTG;
$end;
$component("USB_HOST1");
usb_host_pvt *USB_HOST1;
$end;
$component("GPT");
i_mx6_gpt_pvt *GPT;
$end;
$component("WDOG2");
i_mx6_wdog_pvt *WDOG2;
$end;
$component("WDOG1");
i_mx6_wdog_pvt *WDOG1;
$end;
$component("UART5");
i_mx6_uart_pvt *UART5;
$end;
$component("UART1");
i_mx6_uart_pvt *UART1;
$end;
$component("UART2");
i_mx6_uart_pvt *UART2;
$end;
$component("UART3");
i_mx6_uart_pvt *UART3;
$end;
$component("UART4");
i_mx6_uart_pvt *UART4;
$end;
$component("I2C3");
i_mx6_i2c_pvt *I2C3;
$end;
$component("I2C2");
i_mx6_i2c_pvt *I2C2;
$end;
$component("I2C1");
i_mx6_i2c_pvt *I2C1;
$end;
$component("SDMA");
i_mx6_sdma_pvt *SDMA;
$end;
$component("SPDIF");
i_mx6_spdif_pvt *SPDIF;
$end;
$component("EPIT1");
i_mx6_epit_pvt *EPIT1;
$end;
$component("EPIT2");
i_mx6_epit_pvt *EPIT2;
$end;
$component("CCM");
i_mx6_ccm_pvt *CCM;
$end;
$component("sd_br1");
ahb2axi32_pvt *sd_br1;
$end;
$component("sd_br2");
ahb2axi32_pvt *sd_br2;
$end;
$component("sd_br3");
ahb2axi32_pvt *sd_br3;
$end;
$component("sd_br4");
ahb2axi32_pvt *sd_br4;
$end;
$component("IOMUXC");
i_mx6_iomuxc_pvt *IOMUXC;
$end;
$component("GPIO6");
i_mx6_gpio_pvt *GPIO6;
$end;
$component("GPIO7");
i_mx6_gpio_pvt *GPIO7;
$end;
$component("USB_HOST2");
usb_host_pvt *USB_HOST2;
$end;
$component("USB_HOST3");
usb_host_pvt *USB_HOST3;
$end;
$component("ENET");
i_mx6_enet_pvt *ENET;
$end;
$component("enet_br");
ahb2axi32_pvt *enet_br;
$end;
$component("PWM2");
i_mx6_pwm_pvt *PWM2;
$end;
$component("PWM4");
i_mx6_pwm_pvt *PWM4;
$end;
$component("PWM1");
i_mx6_pwm_pvt *PWM1;
$end;
$component("PWM3");
i_mx6_pwm_pvt *PWM3;
$end;
$component("ECSPI2");
i_mx6_ecspi_pvt *ECSPI2;
$end;
$component("SRC");
i_mx6_src_pvt *SRC;
$end;
$component("ECSPI5");
i_mx6_ecspi_pvt *ECSPI5;
$end;
$component("ECSPI3");
i_mx6_ecspi_pvt *ECSPI3;
$end;
$component("IPU1");
i_mx6_ipu_pvt *IPU1;
$end;
$component("ECSPI1");
i_mx6_ecspi_pvt *ECSPI1;
$end;
$component("ECSPI4");
i_mx6_ecspi_pvt *ECSPI4;
$end;
$component("EEPROM2");
EEPROM_pvt *EEPROM2;
$end;
$component("EEPROM3");
EEPROM_pvt *EEPROM3;
$end;
$component("IPU1_br");
IPU_br_pvt *IPU1_br;
$end;
$component("OCOTP_CTRL");
i_mx6_ocotp_ctrl_pvt *OCOTP_CTRL;
$end;
$component("MMDC1");
i_mx6_mmdc_pvt *MMDC1;
$end;
$component("SNVS");
i_mx6_snvs_pvt *SNVS;
$end;
$component("MMDC2");
i_mx6_mmdc_pvt *MMDC2;
$end;
$component("GPC");
i_mx6_gpc_pvt *GPC;
$end;
$component("PCIe_br");
AXI2GENERIC_br_pvt *PCIe_br;
$end;
$component("PCIe");
i_mx6_pcie_pvt *PCIe;
$end;
$component("SATA_br");
AXI2AHP_br_pvt *SATA_br;
$end;
$component("SATA");
i_mx6_sata_pvt *SATA;
$end;
$component("USB_PHY1");
i_mx6_usbphy_pvt *USB_PHY1;
$end;
$component("USB_PHY2");
i_mx6_usbphy_pvt *USB_PHY2;
$end;
$component("USB_PHY1_br");
ip2apb_pvt *USB_PHY1_br;
$end;
$component("AUDMUX");
i_mx6_audmux_pvt *AUDMUX;
$end;
$component("USB_PHY2_br");
ip2apb_pvt *USB_PHY2_br;
$end;
$component("HDMI_br");
hdmi_br_pvt *HDMI_br;
$end;
$component("HDMI");
i_mx6_hdmi_pvt *HDMI;
$end;
$component("SSI1");
i_mx6_ssi_pvt *SSI1;
$end;
$component("SSI2");
i_mx6_ssi_pvt *SSI2;
$end;
$component("SSI3");
i_mx6_ssi_pvt *SSI3;
$end;
$component("FLASH");
SPI_FLASH_pvt *FLASH;
$end;
$component("USBNC");
USBNC_pvt *USBNC;
$end;
$component("IPU2");
i_mx6_ipu_pvt *IPU2;
$end;
$component("IPU2_br");
IPU_br_pvt *IPU2_br;
$end;
$component("HOST2_br");
usb_br_pvt *HOST2_br;
$end;
$component("OTG_br");
usb_br_pvt *OTG_br;
$end;
$component("HOST3_br");
usb_br_pvt *HOST3_br;
$end;
$component("AHB2APBH");
i_mx6_AHB2APBH_pvt *AHB2APBH;
$end;
$component("APBH_BUS");
apbh_bus_pvt *APBH_BUS;
$end;
$component("ASRC");
i_mx6_asrc_pvt *ASRC;
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
$module_begin("iMX6_SoC");
SC_MODULE(iMX6_SoC) {
public:
  typedef iMX6_SoC SC_CURRENT_USER_MODULE;
  iMX6_SoC(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("GPIO0_IN1"),
GPIO0_IN1("GPIO0_IN1")
$end
$init("GPIO0_OUT0"),
GPIO0_OUT0("GPIO0_OUT0")
$end
$init("I2C1_Bus"),
I2C1_Bus("I2C1_Bus")
$end
$init("IP_BUS"),
IP_BUS(0)
$end
$init("AHB2IP"),
AHB2IP(0)
$end
$init("USB_HOST1"),
USB_HOST1(0)
$end
$init("ECSPI2"),
ECSPI2(0)
$end
$init("USB_HOST2"),
USB_HOST2(0)
$end
$init("USB_HOST3"),
USB_HOST3(0)
$end
$init("PWM1"),
PWM1(0)
$end
$init("HOST2_br"),
HOST2_br(0)
$end
$init("GPIO4"),
GPIO4(0)
$end
$init("sd_br2"),
sd_br2(0)
$end
$init("PCIe_br"),
PCIe_br(0)
$end
$init("GPIO6"),
GPIO6(0)
$end
$init("PWM2"),
PWM2(0)
$end
$init("OCRAM"),
OCRAM(0)
$end
$init("PCIe"),
PCIe(0)
$end
$init("AXI_BUS"),
AXI_BUS(0)
$end
$init("CCM"),
CCM(0)
$end
$init("UART2"),
UART2(0)
$end
$init("uSDHC3"),
uSDHC3(0)
$end
$init("HDMI_br"),
HDMI_br(0)
$end
$init("PWM3"),
PWM3(0)
$end
$init("WDOG2"),
WDOG2(0)
$end
$init("USBNC"),
USBNC(0)
$end
$init("IOMUXC"),
IOMUXC(0)
$end
$init("HDMI"),
HDMI(0)
$end
$init("UART4"),
UART4(0)
$end
$init("ASRC"),
ASRC(0)
$end
$init("SRC"),
SRC(0)
$end
$init("SATA_br"),
SATA_br(0)
$end
$init("uSDHC1"),
uSDHC1(0)
$end
$init("PWM4"),
PWM4(0)
$end
$init("OTG_br"),
OTG_br(0)
$end
$init("SATA"),
SATA(0)
$end
$init("MMDC1"),
MMDC1(0)
$end
$init("ECSPI5"),
ECSPI5(0)
$end
$init("EXT_MEM"),
EXT_MEM(0)
$end
$init("DDR_MEM"),
DDR_MEM(0)
$end
$init("EPIT2"),
EPIT2(0)
$end
$init("USB_PHY1"),
USB_PHY1(0)
$end
$init("CORTEX_A9MP"),
CORTEX_A9MP(0)
$end
$init("GPIO1"),
GPIO1(0)
$end
$init("IPU1_br"),
IPU1_br(0)
$end
$init("ECSPI3"),
ECSPI3(0)
$end
$init("AHB_BUS"),
AHB_BUS(0)
$end
$init("sd_br3"),
sd_br3(0)
$end
$init("APBH_BUS"),
APBH_BUS(0)
$end
$init("L2C_PL310"),
L2C_PL310(0)
$end
$init("I2C1"),
I2C1(0)
$end
$init("SNVS"),
SNVS(0)
$end
$init("IPU1"),
IPU1(0)
$end
$init("GPIO3"),
GPIO3(0)
$end
$init("EEPROM2"),
EEPROM2(0)
$end
$init("IPU2_br"),
IPU2_br(0)
$end
$init("SDMA"),
SDMA(0)
$end
$init("HOST3_br"),
HOST3_br(0)
$end
$init("ENET"),
ENET(0)
$end
$init("ECSPI1"),
ECSPI1(0)
$end
$init("GPIO5"),
GPIO5(0)
$end
$init("AHB2APBH"),
AHB2APBH(0)
$end
$init("SSI1"),
SSI1(0)
$end
$init("I2C2"),
I2C2(0)
$end
$init("IPU2"),
IPU2(0)
$end
$init("sd_br1"),
sd_br1(0)
$end
$init("USB_PHY2"),
USB_PHY2(0)
$end
$init("uSDHC4"),
uSDHC4(0)
$end
$init("GPIO7"),
GPIO7(0)
$end
$init("UART1"),
UART1(0)
$end
$init("FLASH"),
FLASH(0)
$end
$init("WDOG1"),
WDOG1(0)
$end
$init("SSI2"),
SSI2(0)
$end
$init("I2C3"),
I2C3(0)
$end
$init("UART3"),
UART3(0)
$end
$init("ROM"),
ROM(0)
$end
$init("uSDHC2"),
uSDHC2(0)
$end
$init("OCOTP_CTRL"),
OCOTP_CTRL(0)
$end
$init("SSI3"),
SSI3(0)
$end
$init("UART5"),
UART5(0)
$end
$init("USB_PHY1_br"),
USB_PHY1_br(0)
$end
$init("EPIT1"),
EPIT1(0)
$end
$init("USB_OTG"),
USB_OTG(0)
$end
$init("MMDC2"),
MMDC2(0)
$end
$init("ECSPI4"),
ECSPI4(0)
$end
$init("AXI2AHB"),
AXI2AHB(0)
$end
$init("sd_br4"),
sd_br4(0)
$end
$init("GPT"),
GPT(0)
$end
$init("enet_br"),
enet_br(0)
$end
$init("GPC"),
GPC(0)
$end
$init("SPDIF"),
SPDIF(0)
$end
$init("GPIO2"),
GPIO2(0)
$end
$init("AUDMUX"),
AUDMUX(0)
$end
$init("USB_PHY2_br"),
USB_PHY2_br(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("IP_BUS");
IP_BUS = new ip_bus_pvt("IP_BUS");
$end;
$create_component("AHB2IP");
AHB2IP = new ahb2ip_pvt("AHB2IP");
$end;
$create_component("USB_HOST1");
USB_HOST1 = new usb_host_pvt("USB_HOST1");
$end;
$create_component("ECSPI2");
ECSPI2 = new i_mx6_ecspi_pvt("ECSPI2");
$end;
$create_component("USB_HOST2");
USB_HOST2 = new usb_host_pvt("USB_HOST2");
$end;
$create_component("USB_HOST3");
USB_HOST3 = new usb_host_pvt("USB_HOST3");
$end;
$create_component("PWM1");
PWM1 = new i_mx6_pwm_pvt("PWM1");
$end;
$create_component("HOST2_br");
HOST2_br = new usb_br_pvt("HOST2_br");
$end;
$create_component("GPIO4");
GPIO4 = new i_mx6_gpio_pvt("GPIO4");
$end;
$create_component("sd_br2");
sd_br2 = new ahb2axi32_pvt("sd_br2");
$end;
$create_component("PCIe_br");
PCIe_br = new AXI2GENERIC_br_pvt("PCIe_br");
$end;
$create_component("GPIO6");
GPIO6 = new i_mx6_gpio_pvt("GPIO6");
$end;
$create_component("PWM2");
PWM2 = new i_mx6_pwm_pvt("PWM2");
$end;
$create_component("OCRAM");
OCRAM = new ocram_pvt("OCRAM");
$end;
$create_component("PCIe");
PCIe = new i_mx6_pcie_pvt("PCIe");
$end;
$create_component("AXI_BUS");
AXI_BUS = new axi_bus_pvt("AXI_BUS");
$end;
$create_component("CCM");
CCM = new i_mx6_ccm_pvt("CCM");
$end;
$create_component("UART2");
UART2 = new i_mx6_uart_pvt("UART2");
$end;
$create_component("uSDHC3");
uSDHC3 = new i_mx6_usdhc_pvt("uSDHC3");
$end;
$create_component("HDMI_br");
HDMI_br = new hdmi_br_pvt("HDMI_br");
$end;
$create_component("PWM3");
PWM3 = new i_mx6_pwm_pvt("PWM3");
$end;
$create_component("WDOG2");
WDOG2 = new i_mx6_wdog_pvt("WDOG2");
$end;
$create_component("USBNC");
USBNC = new USBNC_pvt("USBNC");
$end;
$create_component("IOMUXC");
IOMUXC = new i_mx6_iomuxc_pvt("IOMUXC");
$end;
$create_component("HDMI");
HDMI = new i_mx6_hdmi_pvt("HDMI");
$end;
$create_component("UART4");
UART4 = new i_mx6_uart_pvt("UART4");
$end;
$create_component("ASRC");
ASRC = new i_mx6_asrc_pvt("ASRC");
$end;
$create_component("SRC");
SRC = new i_mx6_src_pvt("SRC");
$end;
$create_component("SATA_br");
SATA_br = new AXI2AHP_br_pvt("SATA_br");
$end;
$create_component("uSDHC1");
uSDHC1 = new i_mx6_usdhc_pvt("uSDHC1");
$end;
$create_component("PWM4");
PWM4 = new i_mx6_pwm_pvt("PWM4");
$end;
$create_component("OTG_br");
OTG_br = new usb_br_pvt("OTG_br");
$end;
$create_component("SATA");
SATA = new i_mx6_sata_pvt("SATA");
$end;
$create_component("MMDC1");
MMDC1 = new i_mx6_mmdc_pvt("MMDC1");
$end;
$create_component("ECSPI5");
ECSPI5 = new i_mx6_ecspi_pvt("ECSPI5");
$end;
$create_component("EXT_MEM");
EXT_MEM = new ext_memory_pvt("EXT_MEM");
$end;
$create_component("DDR_MEM");
DDR_MEM = new ddr_memory_pvt("DDR_MEM");
$end;
$create_component("EPIT2");
EPIT2 = new i_mx6_epit_pvt("EPIT2");
$end;
$create_component("USB_PHY1");
USB_PHY1 = new i_mx6_usbphy_pvt("USB_PHY1");
$end;
$create_component("CORTEX_A9MP");
CORTEX_A9MP = new Cortex_A9MP_pvt("CORTEX_A9MP");
$end;
$create_component("GPIO1");
GPIO1 = new i_mx6_gpio_pvt("GPIO1");
$end;
$create_component("IPU1_br");
IPU1_br = new IPU_br_pvt("IPU1_br");
$end;
$create_component("ECSPI3");
ECSPI3 = new i_mx6_ecspi_pvt("ECSPI3");
$end;
$create_component("AHB_BUS");
AHB_BUS = new ahb_bus_pvt("AHB_BUS");
$end;
$create_component("sd_br3");
sd_br3 = new ahb2axi32_pvt("sd_br3");
$end;
$create_component("APBH_BUS");
APBH_BUS = new apbh_bus_pvt("APBH_BUS");
$end;
$create_component("L2C_PL310");
L2C_PL310 = new PL310_pvt("L2C_PL310");
$end;
$create_component("I2C1");
I2C1 = new i_mx6_i2c_pvt("I2C1");
$end;
$create_component("SNVS");
SNVS = new i_mx6_snvs_pvt("SNVS");
$end;
$create_component("IPU1");
IPU1 = new i_mx6_ipu_pvt("IPU1");
$end;
$create_component("GPIO3");
GPIO3 = new i_mx6_gpio_pvt("GPIO3");
$end;
$create_component("EEPROM2");
EEPROM2 = new EEPROM_pvt("EEPROM2");
$end;
$create_component("IPU2_br");
IPU2_br = new IPU_br_pvt("IPU2_br");
$end;
$create_component("SDMA");
SDMA = new i_mx6_sdma_pvt("SDMA");
$end;
$create_component("HOST3_br");
HOST3_br = new usb_br_pvt("HOST3_br");
$end;
$create_component("ENET");
ENET = new i_mx6_enet_pvt("ENET");
$end;
$create_component("ECSPI1");
ECSPI1 = new i_mx6_ecspi_pvt("ECSPI1");
$end;
$create_component("GPIO5");
GPIO5 = new i_mx6_gpio_pvt("GPIO5");
$end;
$create_component("AHB2APBH");
AHB2APBH = new i_mx6_AHB2APBH_pvt("AHB2APBH");
$end;
$create_component("SSI1");
SSI1 = new i_mx6_ssi_pvt("SSI1");
$end;
$create_component("I2C2");
I2C2 = new i_mx6_i2c_pvt("I2C2");
$end;
$create_component("IPU2");
IPU2 = new i_mx6_ipu_pvt("IPU2");
$end;
$create_component("sd_br1");
sd_br1 = new ahb2axi32_pvt("sd_br1");
$end;
$create_component("USB_PHY2");
USB_PHY2 = new i_mx6_usbphy_pvt("USB_PHY2");
$end;
$create_component("uSDHC4");
uSDHC4 = new i_mx6_usdhc_pvt("uSDHC4");
$end;
$create_component("GPIO7");
GPIO7 = new i_mx6_gpio_pvt("GPIO7");
$end;
$create_component("UART1");
UART1 = new i_mx6_uart_pvt("UART1");
$end;
$create_component("FLASH");
FLASH = new SPI_FLASH_pvt("FLASH");
$end;
$create_component("WDOG1");
WDOG1 = new i_mx6_wdog_pvt("WDOG1");
$end;
$create_component("SSI2");
SSI2 = new i_mx6_ssi_pvt("SSI2");
$end;
$create_component("I2C3");
I2C3 = new i_mx6_i2c_pvt("I2C3");
$end;
$create_component("UART3");
UART3 = new i_mx6_uart_pvt("UART3");
$end;
$create_component("ROM");
ROM = new rom_pvt("ROM");
$end;
$create_component("uSDHC2");
uSDHC2 = new i_mx6_usdhc_pvt("uSDHC2");
$end;
$create_component("OCOTP_CTRL");
OCOTP_CTRL = new i_mx6_ocotp_ctrl_pvt("OCOTP_CTRL");
$end;
$create_component("SSI3");
SSI3 = new i_mx6_ssi_pvt("SSI3");
$end;
$create_component("UART5");
UART5 = new i_mx6_uart_pvt("UART5");
$end;
$create_component("USB_PHY1_br");
USB_PHY1_br = new ip2apb_pvt("USB_PHY1_br");
$end;
$create_component("EPIT1");
EPIT1 = new i_mx6_epit_pvt("EPIT1");
$end;
$create_component("USB_OTG");
USB_OTG = new usb_otg_pvt("USB_OTG");
$end;
$create_component("MMDC2");
MMDC2 = new i_mx6_mmdc_pvt("MMDC2");
$end;
$create_component("ECSPI4");
ECSPI4 = new i_mx6_ecspi_pvt("ECSPI4");
$end;
$create_component("AXI2AHB");
AXI2AHB = new axi2ahb_pvt("AXI2AHB");
$end;
$create_component("sd_br4");
sd_br4 = new ahb2axi32_pvt("sd_br4");
$end;
$create_component("GPT");
GPT = new i_mx6_gpt_pvt("GPT");
$end;
$create_component("enet_br");
enet_br = new ahb2axi32_pvt("enet_br");
$end;
$create_component("GPC");
GPC = new i_mx6_gpc_pvt("GPC");
$end;
$create_component("SPDIF");
SPDIF = new i_mx6_spdif_pvt("SPDIF");
$end;
$create_component("GPIO2");
GPIO2 = new i_mx6_gpio_pvt("GPIO2");
$end;
$create_component("AUDMUX");
AUDMUX = new i_mx6_audmux_pvt("AUDMUX");
$end;
$create_component("USB_PHY2_br");
USB_PHY2_br = new ip2apb_pvt("USB_PHY2_br");
$end;
$bind("SATA_br->master_1","SATA->AHB_Slave");
vista_bind(SATA_br->master_1, SATA->AHB_Slave);
$end;
$bind("uSDHC1->AHB_Master","sd_br1->slave");
vista_bind(uSDHC1->AHB_Master, sd_br1->slave);
$end;
$bind("IP_BUS->bus_master30","GPIO6->IP_bus_interface");
vista_bind(IP_BUS->bus_master30, GPIO6->IP_bus_interface);
$end;
$bind("IPU1->sync_irq","CORTEX_A9MP->irq_6");
vista_bind(IPU1->sync_irq, CORTEX_A9MP->irq_6);
$end;
$bind("GPT->irq","CORTEX_A9MP->irq_55");
vista_bind(GPT->irq, CORTEX_A9MP->irq_55);
$end;
$bind("WDOG2->irq","CORTEX_A9MP->irq_81");
vista_bind(WDOG2->irq, CORTEX_A9MP->irq_81);
$end;
$bind("AXI_BUS->bus_master0","AXI2AHB->slave_1");
vista_bind(AXI_BUS->bus_master0, AXI2AHB->slave_1);
$end;
$bind("IP_BUS->bus_master23","I2C3->Bus");
vista_bind(IP_BUS->bus_master23, I2C3->Bus);
$end;
$bind("GPIO6->irq_31_16","CORTEX_A9MP->irq_77");
vista_bind(GPIO6->irq_31_16, CORTEX_A9MP->irq_77);
$end;
$bind("GPIO0_IN1","GPIO1->gpio_in_1");
vista_bind(GPIO0_IN1, GPIO1->gpio_in_1);
$end;
$bind("uSDHC3->AHB_Master","sd_br3->slave");
vista_bind(uSDHC3->AHB_Master, sd_br3->slave);
$end;
$bind("UART3->irq","CORTEX_A9MP->irq_28");
vista_bind(UART3->irq, CORTEX_A9MP->irq_28);
$end;
$bind("USB_PHY2_br->master_1","USB_PHY2->APB");
vista_bind(USB_PHY2_br->master_1, USB_PHY2->APB);
$end;
$bind("IP_BUS->bus_master55","SSI3->IP_BUS");
vista_bind(IP_BUS->bus_master55, SSI3->IP_BUS);
$end;
$bind("SSI3->irq","CORTEX_A9MP->irq_48");
vista_bind(SSI3->irq, CORTEX_A9MP->irq_48);
$end;
$bind("sd_br2->master","AXI_BUS->bus_slave8");
vista_bind(sd_br2->master, AXI_BUS->bus_slave8);
$end;
$bind("AXI_BUS->bus_master3","OCRAM->slave");
vista_bind(AXI_BUS->bus_master3, OCRAM->slave);
$end;
$bind("ECSPI5->Data_OUT1","ECSPI5->Data_IN1");
vista_bind(ECSPI5->Data_OUT1, ECSPI5->Data_IN1);
$end;
$bind("ECSPI3->Data_OUT0","ECSPI3->Data_IN0");
vista_bind(ECSPI3->Data_OUT0, ECSPI3->Data_IN0);
$end;
$bind("EPIT1->INTR","CORTEX_A9MP->irq_56");
vista_bind(EPIT1->INTR, CORTEX_A9MP->irq_56);
$end;
$bind("IPU1->Memory","AXI_BUS->bus_slave5");
vista_bind(IPU1->Memory, AXI_BUS->bus_slave5);
$end;
$bind("SRC->n_reset_3","CORTEX_A9MP->n_reset_3");
vista_bind(SRC->n_reset_3, CORTEX_A9MP->n_reset_3);
$end;
$bind("SDMA->IRQ","CORTEX_A9MP->irq_2");
vista_bind(SDMA->IRQ, CORTEX_A9MP->irq_2);
$end;
$bind("GPIO1->irq_4","CORTEX_A9MP->irq_61");
vista_bind(GPIO1->irq_4, CORTEX_A9MP->irq_61);
$end;
$bind("enet_br->master","AXI_BUS->bus_slave11");
vista_bind(enet_br->master, AXI_BUS->bus_slave11);
$end;
$bind("PWM2->IRQ","CORTEX_A9MP->irq_84");
vista_bind(PWM2->IRQ, CORTEX_A9MP->irq_84);
$end;
$bind("I2C1->i2c_bus","I2C1_Bus");
vista_bind(I2C1->i2c_bus, I2C1_Bus);
$end;
$bind("IPU2->sync_irq","CORTEX_A9MP->irq_8");
vista_bind(IPU2->sync_irq, CORTEX_A9MP->irq_8);
$end;
$bind("I2C2->i2c_bus","EEPROM2->Slave");
vista_bind(I2C2->i2c_bus, EEPROM2->Slave);
$end;
$bind("IP_BUS->bus_master56","USBNC->slave");
vista_bind(IP_BUS->bus_master56, USBNC->slave);
$end;
$bind("IPU1_br->master_1","IPU1->slave");
vista_bind(IPU1_br->master_1, IPU1->slave);
$end;
$bind("IP_BUS->bus_master4","GPIO1->IP_bus_interface");
vista_bind(IP_BUS->bus_master4, GPIO1->IP_bus_interface);
$end;
$bind("IOMUXC->irq","CORTEX_A9MP->irq_0");
vista_bind(IOMUXC->irq, CORTEX_A9MP->irq_0);
$end;
$bind("SNVS->irq1","CORTEX_A9MP->irq_4");
vista_bind(SNVS->irq1, CORTEX_A9MP->irq_4);
$end;
$bind("SRC->n_reset_2","CORTEX_A9MP->n_reset_2");
vista_bind(SRC->n_reset_2, CORTEX_A9MP->n_reset_2);
$end;
$bind("IP_BUS->bus_master49","SNVS->slave");
vista_bind(IP_BUS->bus_master49, SNVS->slave);
$end;
$bind("HOST3_br->master","USB_HOST3->host");
vista_bind(HOST3_br->master, USB_HOST3->host);
$end;
$bind("IP_BUS->bus_master17","UART2->IP_bus_interface");
vista_bind(IP_BUS->bus_master17, UART2->IP_bus_interface);
$end;
$bind("L2C_PL310->Master0","AXI_BUS->bus_slave0");
vista_bind(L2C_PL310->Master0, AXI_BUS->bus_slave0);
$end;
$bind("ECSPI5->Data_OUT0","ECSPI5->Data_IN0");
vista_bind(ECSPI5->Data_OUT0, ECSPI5->Data_IN0);
$end;
$bind("GPIO2->irq_15_0","CORTEX_A9MP->irq_68");
vista_bind(GPIO2->irq_15_0, CORTEX_A9MP->irq_68);
$end;
$bind("uSDHC3->uSDHC_irq","CORTEX_A9MP->irq_24");
vista_bind(uSDHC3->uSDHC_irq, CORTEX_A9MP->irq_24);
$end;
$bind("ENET->irq","CORTEX_A9MP->irq_118");
vista_bind(ENET->irq, CORTEX_A9MP->irq_118);
$end;
$bind("UART5->irq","CORTEX_A9MP->irq_30");
vista_bind(UART5->irq, CORTEX_A9MP->irq_30);
$end;
$bind("PWM3->IRQ","CORTEX_A9MP->irq_85");
vista_bind(PWM3->IRQ, CORTEX_A9MP->irq_85);
$end;
$bind("USB_HOST2->dma_port","AXI_BUS->bus_slave2");
vista_bind(USB_HOST2->dma_port, AXI_BUS->bus_slave2);
$end;
$bind("IP_BUS->bus_master52","AUDMUX->Slave");
vista_bind(IP_BUS->bus_master52, AUDMUX->Slave);
$end;
$bind("IP_BUS->bus_master28","EPIT2->SLAVE");
vista_bind(IP_BUS->bus_master28, EPIT2->SLAVE);
$end;
$bind("L2C_PL310->Master1","AXI_BUS->bus_slave1");
vista_bind(L2C_PL310->Master1, AXI_BUS->bus_slave1);
$end;
$bind("IP_BUS->bus_master35","PWM1->SLAVE");
vista_bind(IP_BUS->bus_master35, PWM1->SLAVE);
$end;
$bind("AHB_BUS->bus_master0","AHB2IP->slave_1");
vista_bind(AHB_BUS->bus_master0, AHB2IP->slave_1);
$end;
$bind("SRC->n_reset_1","CORTEX_A9MP->n_reset_1");
vista_bind(SRC->n_reset_1, CORTEX_A9MP->n_reset_1);
$end;
$bind("GPIO1->irq_2","CORTEX_A9MP->irq_63");
vista_bind(GPIO1->irq_2, CORTEX_A9MP->irq_63);
$end;
$bind("ECSPI2->Data_OUT3","ECSPI2->Data_IN3");
vista_bind(ECSPI2->Data_OUT3, ECSPI2->Data_IN3);
$end;
$bind("IP_BUS->bus_master27","EPIT1->SLAVE");
vista_bind(IP_BUS->bus_master27, EPIT1->SLAVE);
$end;
$bind("SPDIF->SPDIFOUT","SPDIF->SPDIFIN");
vista_bind(SPDIF->SPDIFOUT, SPDIF->SPDIFIN);
$end;
$bind("HOST2_br->master","USB_HOST2->host");
vista_bind(HOST2_br->master, USB_HOST2->host);
$end;
$bind("IP_BUS->bus_master43","ECSPI5->Slave");
vista_bind(IP_BUS->bus_master43, ECSPI5->Slave);
$end;
$bind("AXI_BUS->bus_master5","IPU1_br->slave_1");
vista_bind(AXI_BUS->bus_master5, IPU1_br->slave_1);
$end;
$bind("GPIO1->irq_3","CORTEX_A9MP->irq_62");
vista_bind(GPIO1->irq_3, CORTEX_A9MP->irq_62);
$end;
$bind("ECSPI4->IRQ","CORTEX_A9MP->irq_34");
vista_bind(ECSPI4->IRQ, CORTEX_A9MP->irq_34);
$end;
$bind("IP_BUS->bus_master25","SPDIF->Bus");
vista_bind(IP_BUS->bus_master25, SPDIF->Bus);
$end;
$bind("uSDHC1->uSDHC_irq","CORTEX_A9MP->irq_22");
vista_bind(uSDHC1->uSDHC_irq, CORTEX_A9MP->irq_22);
$end;
$bind("PWM4->IRQ","CORTEX_A9MP->irq_86");
vista_bind(PWM4->IRQ, CORTEX_A9MP->irq_86);
$end;
$bind("IP_BUS->bus_master47","MMDC1->IP_BUS");
vista_bind(IP_BUS->bus_master47, MMDC1->IP_BUS);
$end;
$bind("SDMA->PDMA_Master","AHB_BUS->bus_slave5");
vista_bind(SDMA->PDMA_Master, AHB_BUS->bus_slave5);
$end;
$bind("GPC->irq","CORTEX_A9MP->irq_89");
vista_bind(GPC->irq, CORTEX_A9MP->irq_89);
$end;
$bind("GPIO1->irq_31_16","CORTEX_A9MP->irq_67");
vista_bind(GPIO1->irq_31_16, CORTEX_A9MP->irq_67);
$end;
$bind("IPU2_br->master_1","IPU2->slave");
vista_bind(IPU2_br->master_1, IPU2->slave);
$end;
$bind("PCIe_br->master_1","PCIe->Slave");
vista_bind(PCIe_br->master_1, PCIe->Slave);
$end;
$bind("IP_BUS->bus_master11","HOST2_br->slave");
vista_bind(IP_BUS->bus_master11, HOST2_br->slave);
$end;
$bind("GPIO4->irq_15_0","CORTEX_A9MP->irq_72");
vista_bind(GPIO4->irq_15_0, CORTEX_A9MP->irq_72);
$end;
$bind("USB_PHY1_br->master_1","USB_PHY1->APB");
vista_bind(USB_PHY1_br->master_1, USB_PHY1->APB);
$end;
$bind("AXI_BUS->bus_master8","HDMI_br->slave_1");
vista_bind(AXI_BUS->bus_master8, HDMI_br->slave_1);
$end;
$bind("HDMI_br->master_1","HDMI->AHB_slave");
vista_bind(HDMI_br->master_1, HDMI->AHB_slave);
$end;
$bind("ECSPI4->Data_OUT3","ECSPI4->Data_IN3");
vista_bind(ECSPI4->Data_OUT3, ECSPI4->Data_IN3);
$end;
$bind("ECSPI2->Data_OUT2","ECSPI2->Data_IN2");
vista_bind(ECSPI2->Data_OUT2, ECSPI2->Data_IN2);
$end;
$bind("AHB2APBH->APB_Master","APBH_BUS->bus_slave0");
vista_bind(AHB2APBH->APB_Master, APBH_BUS->bus_slave0);
$end;
$bind("IP_BUS->bus_master32","IOMUXC->IOMUX_Slave");
vista_bind(IP_BUS->bus_master32, IOMUXC->IOMUX_Slave);
$end;
$bind("IP_BUS->bus_master34","SRC->host");
vista_bind(IP_BUS->bus_master34, SRC->host);
$end;
$bind("IP_BUS->bus_master15","ENET->SIF");
vista_bind(IP_BUS->bus_master15, ENET->SIF);
$end;
$bind("IP_BUS->bus_master16","UART1->IP_bus_interface");
vista_bind(IP_BUS->bus_master16, UART1->IP_bus_interface);
$end;
$bind("ECSPI2->IRQ","CORTEX_A9MP->irq_32");
vista_bind(ECSPI2->IRQ, CORTEX_A9MP->irq_32);
$end;
$bind("IP_BUS->bus_master22","I2C2->Bus");
vista_bind(IP_BUS->bus_master22, I2C2->Bus);
$end;
$bind("IP_BUS->bus_master24","SDMA->IP_Slave");
vista_bind(IP_BUS->bus_master24, SDMA->IP_Slave);
$end;
$bind("GPIO6->irq_15_0","CORTEX_A9MP->irq_76");
vista_bind(GPIO6->irq_15_0, CORTEX_A9MP->irq_76);
$end;
$bind("GPIO1->irq_1","CORTEX_A9MP->irq_64");
vista_bind(GPIO1->irq_1, CORTEX_A9MP->irq_64);
$end;
$bind("AXI_BUS->bus_master2","DDR_MEM->slave");
vista_bind(AXI_BUS->bus_master2, DDR_MEM->slave);
$end;
$bind("IP_BUS->bus_master8","GPIO4->IP_bus_interface");
vista_bind(IP_BUS->bus_master8, GPIO4->IP_bus_interface);
$end;
$bind("IP_BUS->bus_master20","UART5->IP_bus_interface");
vista_bind(IP_BUS->bus_master20, UART5->IP_bus_interface);
$end;
$bind("IP_BUS->bus_master14","WDOG2->Bus");
vista_bind(IP_BUS->bus_master14, WDOG2->Bus);
$end;
$bind("GPIO3->irq_31_16","CORTEX_A9MP->irq_71");
vista_bind(GPIO3->irq_31_16, CORTEX_A9MP->irq_71);
$end;
$bind("IPU1->touch_irq","GPIO1->gpio_in_9");
vista_bind(IPU1->touch_irq, GPIO1->gpio_in_9);
$end;
$bind("AHB2IP->master_1","IP_BUS->bus_slave0");
vista_bind(AHB2IP->master_1, IP_BUS->bus_slave0);
$end;
$bind("ECSPI4->Data_OUT2","ECSPI4->Data_IN2");
vista_bind(ECSPI4->Data_OUT2, ECSPI4->Data_IN2);
$end;
$bind("ECSPI2->Data_OUT1","ECSPI2->Data_IN1");
vista_bind(ECSPI2->Data_OUT1, ECSPI2->Data_IN1);
$end;
$bind("IP_BUS->bus_master46","GPC->IP_BUS");
vista_bind(IP_BUS->bus_master46, GPC->IP_BUS);
$end;
$bind("AXI_BUS->bus_master4","AXI2AHB->slave_2");
vista_bind(AXI_BUS->bus_master4, AXI2AHB->slave_2);
$end;
$bind("USB_HOST2->irq","CORTEX_A9MP->irq_41");
vista_bind(USB_HOST2->irq, CORTEX_A9MP->irq_41);
$end;
$bind("USB_PHY1->irq","CORTEX_A9MP->irq_44");
vista_bind(USB_PHY1->irq, CORTEX_A9MP->irq_44);
$end;
$bind("IP_BUS->bus_master36","PWM2->SLAVE");
vista_bind(IP_BUS->bus_master36, PWM2->SLAVE);
$end;
$bind("IP_BUS->bus_master51","USB_PHY1_br->slave_1");
vista_bind(IP_BUS->bus_master51, USB_PHY1_br->slave_1);
$end;
$bind("IP_BUS->bus_master10","OTG_br->slave");
vista_bind(IP_BUS->bus_master10, OTG_br->slave);
$end;
$bind("USB_OTG->dma_port","AXI_BUS->bus_slave3");
vista_bind(USB_OTG->dma_port, AXI_BUS->bus_slave3);
$end;
$bind("IP_BUS->bus_master42","ECSPI4->Slave");
vista_bind(IP_BUS->bus_master42, ECSPI4->Slave);
$end;
$bind("WDOG1->irq","CORTEX_A9MP->irq_80");
vista_bind(WDOG1->irq, CORTEX_A9MP->irq_80);
$end;
$bind("IP_BUS->bus_master29","CCM->Slave");
vista_bind(IP_BUS->bus_master29, CCM->Slave);
$end;
$bind("GPIO5->irq_31_16","CORTEX_A9MP->irq_75");
vista_bind(GPIO5->irq_31_16, CORTEX_A9MP->irq_75);
$end;
$bind("IP_BUS->bus_master3","uSDHC4->IP_Slave");
vista_bind(IP_BUS->bus_master3, uSDHC4->IP_Slave);
$end;
$bind("CORTEX_A9MP->master1","L2C_PL310->Slave1");
vista_bind(CORTEX_A9MP->master1, L2C_PL310->Slave1);
$end;
$bind("IP_BUS->bus_master2","uSDHC3->IP_Slave");
vista_bind(IP_BUS->bus_master2, uSDHC3->IP_Slave);
$end;
$bind("IP_BUS->bus_master1","uSDHC2->IP_Slave");
vista_bind(IP_BUS->bus_master1, uSDHC2->IP_Slave);
$end;
$bind("IP_BUS->bus_master48","MMDC2->IP_BUS");
vista_bind(IP_BUS->bus_master48, MMDC2->IP_BUS);
$end;
$bind("PCIe->irq1","CORTEX_A9MP->irq_120");
vista_bind(PCIe->irq1, CORTEX_A9MP->irq_120);
$end;
$bind("IP_BUS->bus_master0","uSDHC1->IP_Slave");
vista_bind(IP_BUS->bus_master0, uSDHC1->IP_Slave);
$end;
$bind("sd_br3->master","AXI_BUS->bus_slave7");
vista_bind(sd_br3->master, AXI_BUS->bus_slave7);
$end;
$bind("IOMUXC->sdcard_detect","GPIO7->gpio_in_0");
vista_bind(IOMUXC->sdcard_detect, GPIO7->gpio_in_0);
$end;
$bind("IP_BUS->bus_master57","ASRC->Slave");
vista_bind(IP_BUS->bus_master57, ASRC->Slave);
$end;
$bind("HDMI->irq1","CORTEX_A9MP->irq_115");
vista_bind(HDMI->irq1, CORTEX_A9MP->irq_115);
$end;
$bind("UART2->irq","CORTEX_A9MP->irq_27");
vista_bind(UART2->irq, CORTEX_A9MP->irq_27);
$end;
$bind("ECSPI4->Data_OUT1","ECSPI4->Data_IN1");
vista_bind(ECSPI4->Data_OUT1, ECSPI4->Data_IN1);
$end;
$bind("ECSPI2->Data_OUT0","ECSPI2->Data_IN0");
vista_bind(ECSPI2->Data_OUT0, ECSPI2->Data_IN0);
$end;
$bind("IP_BUS->bus_master41","ECSPI3->Slave");
vista_bind(IP_BUS->bus_master41, ECSPI3->Slave);
$end;
$bind("uSDHC2->AHB_Master","sd_br2->slave");
vista_bind(uSDHC2->AHB_Master, sd_br2->slave);
$end;
$bind("SATA->irq","CORTEX_A9MP->irq_39");
vista_bind(SATA->irq, CORTEX_A9MP->irq_39);
$end;
$bind("AXI_BUS->bus_master6","SATA_br->slave_1");
vista_bind(AXI_BUS->bus_master6, SATA_br->slave_1);
$end;
$bind("SPDIF->irq","CORTEX_A9MP->irq_52");
vista_bind(SPDIF->irq, CORTEX_A9MP->irq_52);
$end;
$bind("SDMA->Periph_Master","IP_BUS->bus_slave1");
vista_bind(SDMA->Periph_Master, IP_BUS->bus_slave1);
$end;
$bind("IP_BUS->bus_master39","ECSPI1->Slave");
vista_bind(IP_BUS->bus_master39, ECSPI1->Slave);
$end;
$bind("IP_BUS->bus_master13","WDOG1->Bus");
vista_bind(IP_BUS->bus_master13, WDOG1->Bus);
$end;
$bind("AHB2APBH->AHB_Master","AHB_BUS->bus_slave4");
vista_bind(AHB2APBH->AHB_Master, AHB_BUS->bus_slave4);
$end;
$bind("GPIO1->irq_0","CORTEX_A9MP->irq_65");
vista_bind(GPIO1->irq_0, CORTEX_A9MP->irq_65);
$end;
$bind("PCIe->irq2","CORTEX_A9MP->irq_121");
vista_bind(PCIe->irq2, CORTEX_A9MP->irq_121);
$end;
$bind("HDMI->irq2","CORTEX_A9MP->irq_116");
vista_bind(HDMI->irq2, CORTEX_A9MP->irq_116);
$end;
$bind("uSDHC4->AHB_Master","sd_br4->slave");
vista_bind(uSDHC4->AHB_Master, sd_br4->slave);
$end;
$bind("IP_BUS->bus_master40","ECSPI2->Slave");
vista_bind(IP_BUS->bus_master40, ECSPI2->Slave);
$end;
$bind("GPIO7->irq_31_16","CORTEX_A9MP->irq_79");
vista_bind(GPIO7->irq_31_16, CORTEX_A9MP->irq_79);
$end;
$bind("IP_BUS->bus_master7","GPIO3->IP_bus_interface");
vista_bind(IP_BUS->bus_master7, GPIO3->IP_bus_interface);
$end;
$bind("IP_BUS->bus_master50","USB_PHY2_br->slave_1");
vista_bind(IP_BUS->bus_master50, USB_PHY2_br->slave_1);
$end;
$bind("IP_BUS->bus_master53","SSI1->IP_BUS");
vista_bind(IP_BUS->bus_master53, SSI1->IP_BUS);
$end;
$bind("UART4->irq","CORTEX_A9MP->irq_29");
vista_bind(UART4->irq, CORTEX_A9MP->irq_29);
$end;
$bind("EPIT2->INTR","CORTEX_A9MP->irq_57");
vista_bind(EPIT2->INTR, CORTEX_A9MP->irq_57);
$end;
$bind("sd_br1->master","AXI_BUS->bus_slave9");
vista_bind(sd_br1->master, AXI_BUS->bus_slave9);
$end;
$bind("IPU2->Memory","AXI_BUS->bus_slave12");
vista_bind(IPU2->Memory, AXI_BUS->bus_slave12);
$end;
$bind("IP_BUS->bus_master19","UART4->IP_bus_interface");
vista_bind(IP_BUS->bus_master19, UART4->IP_bus_interface);
$end;
$bind("USB_PHY2->irq","CORTEX_A9MP->irq_45");
vista_bind(USB_PHY2->irq, CORTEX_A9MP->irq_45);
$end;
$bind("ECSPI4->Data_OUT0","ECSPI4->Data_IN0");
vista_bind(ECSPI4->Data_OUT0, ECSPI4->Data_IN0);
$end;
$bind("uSDHC4->uSDHC_irq","CORTEX_A9MP->irq_25");
vista_bind(uSDHC4->uSDHC_irq, CORTEX_A9MP->irq_25);
$end;
$bind("SNVS->irq3","CORTEX_A9MP->irq_20");
vista_bind(SNVS->irq3, CORTEX_A9MP->irq_20);
$end;
$bind("GPIO1->irq_15_0","CORTEX_A9MP->irq_66");
vista_bind(GPIO1->irq_15_0, CORTEX_A9MP->irq_66);
$end;
$bind("AXI_BUS->bus_master7","PCIe_br->slave_1");
vista_bind(AXI_BUS->bus_master7, PCIe_br->slave_1);
$end;
$bind("IP_BUS->bus_master5","GPIO5->IP_bus_interface");
vista_bind(IP_BUS->bus_master5, GPIO5->IP_bus_interface);
$end;
$bind("ECSPI1->Data_OUT0","FLASH->Slave");
vista_bind(ECSPI1->Data_OUT0, FLASH->Slave);
$end;
$bind("ECSPI1->Data_OUT3","ECSPI1->Data_IN3");
vista_bind(ECSPI1->Data_OUT3, ECSPI1->Data_IN3);
$end;
$bind("GPIO1->gpio_out_0","GPIO0_OUT0");
vista_bind(GPIO1->gpio_out_0, GPIO0_OUT0);
$end;
$bind("IP_BUS->bus_master33","HOST3_br->slave");
vista_bind(IP_BUS->bus_master33, HOST3_br->slave);
$end;
$bind("AXI_BUS->bus_master1","EXT_MEM->slave");
vista_bind(AXI_BUS->bus_master1, EXT_MEM->slave);
$end;
$bind("IP_BUS->bus_master37","PWM3->SLAVE");
vista_bind(IP_BUS->bus_master37, PWM3->SLAVE);
$end;
$bind("IPU1->err_irq","CORTEX_A9MP->irq_5");
vista_bind(IPU1->err_irq, CORTEX_A9MP->irq_5);
$end;
$bind("GPIO1->irq_6","CORTEX_A9MP->irq_59");
vista_bind(GPIO1->irq_6, CORTEX_A9MP->irq_59);
$end;
$bind("ECSPI5->IRQ","CORTEX_A9MP->irq_35");
vista_bind(ECSPI5->IRQ, CORTEX_A9MP->irq_35);
$end;
$bind("I2C1->irq","CORTEX_A9MP->irq_36");
vista_bind(I2C1->irq, CORTEX_A9MP->irq_36);
$end;
$bind("OTG_br->master","USB_OTG->host");
vista_bind(OTG_br->master, USB_OTG->host);
$end;
$bind("IP_BUS->bus_master21","I2C1->Bus");
vista_bind(IP_BUS->bus_master21, I2C1->Bus);
$end;
$bind("uSDHC2->uSDHC_irq","CORTEX_A9MP->irq_23");
vista_bind(uSDHC2->uSDHC_irq, CORTEX_A9MP->irq_23);
$end;
$bind("ENET->Master","enet_br->slave");
vista_bind(ENET->Master, enet_br->slave);
$end;
$bind("GPIO1->irq_7","CORTEX_A9MP->irq_58");
vista_bind(GPIO1->irq_7, CORTEX_A9MP->irq_58);
$end;
$bind("SNVS->irq2","CORTEX_A9MP->irq_19");
vista_bind(SNVS->irq2, CORTEX_A9MP->irq_19);
$end;
$bind("GPIO3->irq_15_0","CORTEX_A9MP->irq_70");
vista_bind(GPIO3->irq_15_0, CORTEX_A9MP->irq_70);
$end;
$bind("ECSPI3->Data_OUT3","ECSPI3->Data_IN3");
vista_bind(ECSPI3->Data_OUT3, ECSPI3->Data_IN3);
$end;
$bind("ECSPI1->Data_OUT2","ECSPI1->Data_IN2");
vista_bind(ECSPI1->Data_OUT2, ECSPI1->Data_IN2);
$end;
$bind("IP_BUS->bus_master44","OCOTP_CTRL->host");
vista_bind(IP_BUS->bus_master44, OCOTP_CTRL->host);
$end;
$bind("IPU2->err_irq","CORTEX_A9MP->irq_7");
vista_bind(IPU2->err_irq, CORTEX_A9MP->irq_7);
$end;
$bind("ENET->phy_gpio","GPIO1->gpio_in_28");
vista_bind(ENET->phy_gpio, GPIO1->gpio_in_28);
$end;
$bind("PCIe->irq3","CORTEX_A9MP->irq_122");
vista_bind(PCIe->irq3, CORTEX_A9MP->irq_122);
$end;
$bind("IP_BUS->bus_master18","UART3->IP_bus_interface");
vista_bind(IP_BUS->bus_master18, UART3->IP_bus_interface);
$end;
$bind("I2C2->irq","CORTEX_A9MP->irq_37");
vista_bind(I2C2->irq, CORTEX_A9MP->irq_37);
$end;
$bind("AXI2AHB->master_1","AHB_BUS->bus_slave0");
vista_bind(AXI2AHB->master_1, AHB_BUS->bus_slave0);
$end;
$bind("ECSPI3->IRQ","CORTEX_A9MP->irq_33");
vista_bind(ECSPI3->IRQ, CORTEX_A9MP->irq_33);
$end;
$bind("AXI_BUS->bus_master9","IPU2_br->slave_1");
vista_bind(AXI_BUS->bus_master9, IPU2_br->slave_1);
$end;
$bind("IP_BUS->bus_master54","SSI2->IP_BUS");
vista_bind(IP_BUS->bus_master54, SSI2->IP_BUS);
$end;
$bind("GPIO2->irq_31_16","CORTEX_A9MP->irq_69");
vista_bind(GPIO2->irq_31_16, CORTEX_A9MP->irq_69);
$end;
$bind("IP_BUS->bus_master31","GPIO7->IP_bus_interface");
vista_bind(IP_BUS->bus_master31, GPIO7->IP_bus_interface);
$end;
$bind("PCIe->irq4","CORTEX_A9MP->irq_123");
vista_bind(PCIe->irq4, CORTEX_A9MP->irq_123);
$end;
$bind("GPIO5->irq_15_0","CORTEX_A9MP->irq_74");
vista_bind(GPIO5->irq_15_0, CORTEX_A9MP->irq_74);
$end;
$bind("AHB_BUS->bus_master2","AHB2APBH->AHB_Slave");
vista_bind(AHB_BUS->bus_master2, AHB2APBH->AHB_Slave);
$end;
$bind("CORTEX_A9MP->master0","L2C_PL310->Slave0");
vista_bind(CORTEX_A9MP->master0, L2C_PL310->Slave0);
$end;
$bind("CCM->irq1","CORTEX_A9MP->irq_87");
vista_bind(CCM->irq1, CORTEX_A9MP->irq_87);
$end;
$bind("ECSPI5->Data_OUT3","ECSPI5->Data_IN3");
vista_bind(ECSPI5->Data_OUT3, ECSPI5->Data_IN3);
$end;
$bind("ECSPI3->Data_OUT2","ECSPI3->Data_IN2");
vista_bind(ECSPI3->Data_OUT2, ECSPI3->Data_IN2);
$end;
$bind("ECSPI1->Data_OUT1","ECSPI1->Data_IN1");
vista_bind(ECSPI1->Data_OUT1, ECSPI1->Data_IN1);
$end;
$bind("SSI1->irq","CORTEX_A9MP->irq_46");
vista_bind(SSI1->irq, CORTEX_A9MP->irq_46);
$end;
$bind("USB_HOST3->irq","CORTEX_A9MP->irq_42");
vista_bind(USB_HOST3->irq, CORTEX_A9MP->irq_42);
$end;
$bind("USB_OTG->irq","CORTEX_A9MP->irq_43");
vista_bind(USB_OTG->irq, CORTEX_A9MP->irq_43);
$end;
$bind("I2C3->irq","CORTEX_A9MP->irq_38");
vista_bind(I2C3->irq, CORTEX_A9MP->irq_38);
$end;
$bind("I2C3->i2c_bus","IPU1->touch_if");
vista_bind(I2C3->i2c_bus, IPU1->touch_if);
$end;
$bind("ECSPI1->IRQ","CORTEX_A9MP->irq_31");
vista_bind(ECSPI1->IRQ, CORTEX_A9MP->irq_31);
$end;
$bind("CCM->irq2","CORTEX_A9MP->irq_88");
vista_bind(CCM->irq2, CORTEX_A9MP->irq_88);
$end;
$bind("SDMA->BDMA_Master","AHB_BUS->bus_slave6");
vista_bind(SDMA->BDMA_Master, AHB_BUS->bus_slave6);
$end;
$bind("IP_BUS->bus_master38","PWM4->SLAVE");
vista_bind(IP_BUS->bus_master38, PWM4->SLAVE);
$end;
$bind("GPIO7->irq_15_0","CORTEX_A9MP->irq_78");
vista_bind(GPIO7->irq_15_0, CORTEX_A9MP->irq_78);
$end;
$bind("AHB_BUS->bus_master1","ROM->slave");
vista_bind(AHB_BUS->bus_master1, ROM->slave);
$end;
$bind("GPIO1->irq_5","CORTEX_A9MP->irq_60");
vista_bind(GPIO1->irq_5, CORTEX_A9MP->irq_60);
$end;
$bind("USB_HOST3->dma_port","AXI_BUS->bus_slave10");
vista_bind(USB_HOST3->dma_port, AXI_BUS->bus_slave10);
$end;
$bind("IP_BUS->bus_master12","GPT->slave");
vista_bind(IP_BUS->bus_master12, GPT->slave);
$end;
$bind("IP_BUS->bus_master6","GPIO2->IP_bus_interface");
vista_bind(IP_BUS->bus_master6, GPIO2->IP_bus_interface);
$end;
$bind("sd_br4->master","AXI_BUS->bus_slave6");
vista_bind(sd_br4->master, AXI_BUS->bus_slave6);
$end;
$bind("GPIO4->irq_31_16","CORTEX_A9MP->irq_73");
vista_bind(GPIO4->irq_31_16, CORTEX_A9MP->irq_73);
$end;
$bind("ASRC->IRQ","CORTEX_A9MP->irq_50");
vista_bind(ASRC->IRQ, CORTEX_A9MP->irq_50);
$end;
$bind("SSI2->irq","CORTEX_A9MP->irq_47");
vista_bind(SSI2->irq, CORTEX_A9MP->irq_47);
$end;
$bind("USB_HOST1->irq","CORTEX_A9MP->irq_40");
vista_bind(USB_HOST1->irq, CORTEX_A9MP->irq_40);
$end;
$bind("ECSPI5->Data_OUT2","ECSPI5->Data_IN2");
vista_bind(ECSPI5->Data_OUT2, ECSPI5->Data_IN2);
$end;
$bind("ECSPI3->Data_OUT1","ECSPI3->Data_IN1");
vista_bind(ECSPI3->Data_OUT1, ECSPI3->Data_IN1);
$end;
$bind("UART1->irq","CORTEX_A9MP->irq_26");
vista_bind(UART1->irq, CORTEX_A9MP->irq_26);
$end;
$bind("USB_HOST1->dma_port","AXI_BUS->bus_slave4");
vista_bind(USB_HOST1->dma_port, AXI_BUS->bus_slave4);
$end;
$bind("IP_BUS->bus_master9","USB_HOST1->host");
vista_bind(IP_BUS->bus_master9, USB_HOST1->host);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "schematics";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~iMX6_SoC() {
    $destructor_begin;
$destruct_component("IP_BUS");
delete IP_BUS; IP_BUS = 0;
$end;
$destruct_component("AHB2IP");
delete AHB2IP; AHB2IP = 0;
$end;
$destruct_component("USB_HOST1");
delete USB_HOST1; USB_HOST1 = 0;
$end;
$destruct_component("ECSPI2");
delete ECSPI2; ECSPI2 = 0;
$end;
$destruct_component("USB_HOST2");
delete USB_HOST2; USB_HOST2 = 0;
$end;
$destruct_component("USB_HOST3");
delete USB_HOST3; USB_HOST3 = 0;
$end;
$destruct_component("PWM1");
delete PWM1; PWM1 = 0;
$end;
$destruct_component("HOST2_br");
delete HOST2_br; HOST2_br = 0;
$end;
$destruct_component("GPIO4");
delete GPIO4; GPIO4 = 0;
$end;
$destruct_component("sd_br2");
delete sd_br2; sd_br2 = 0;
$end;
$destruct_component("PCIe_br");
delete PCIe_br; PCIe_br = 0;
$end;
$destruct_component("GPIO6");
delete GPIO6; GPIO6 = 0;
$end;
$destruct_component("PWM2");
delete PWM2; PWM2 = 0;
$end;
$destruct_component("OCRAM");
delete OCRAM; OCRAM = 0;
$end;
$destruct_component("PCIe");
delete PCIe; PCIe = 0;
$end;
$destruct_component("AXI_BUS");
delete AXI_BUS; AXI_BUS = 0;
$end;
$destruct_component("CCM");
delete CCM; CCM = 0;
$end;
$destruct_component("UART2");
delete UART2; UART2 = 0;
$end;
$destruct_component("uSDHC3");
delete uSDHC3; uSDHC3 = 0;
$end;
$destruct_component("HDMI_br");
delete HDMI_br; HDMI_br = 0;
$end;
$destruct_component("PWM3");
delete PWM3; PWM3 = 0;
$end;
$destruct_component("WDOG2");
delete WDOG2; WDOG2 = 0;
$end;
$destruct_component("USBNC");
delete USBNC; USBNC = 0;
$end;
$destruct_component("IOMUXC");
delete IOMUXC; IOMUXC = 0;
$end;
$destruct_component("HDMI");
delete HDMI; HDMI = 0;
$end;
$destruct_component("UART4");
delete UART4; UART4 = 0;
$end;
$destruct_component("ASRC");
delete ASRC; ASRC = 0;
$end;
$destruct_component("SRC");
delete SRC; SRC = 0;
$end;
$destruct_component("SATA_br");
delete SATA_br; SATA_br = 0;
$end;
$destruct_component("uSDHC1");
delete uSDHC1; uSDHC1 = 0;
$end;
$destruct_component("PWM4");
delete PWM4; PWM4 = 0;
$end;
$destruct_component("OTG_br");
delete OTG_br; OTG_br = 0;
$end;
$destruct_component("SATA");
delete SATA; SATA = 0;
$end;
$destruct_component("MMDC1");
delete MMDC1; MMDC1 = 0;
$end;
$destruct_component("ECSPI5");
delete ECSPI5; ECSPI5 = 0;
$end;
$destruct_component("EXT_MEM");
delete EXT_MEM; EXT_MEM = 0;
$end;
$destruct_component("DDR_MEM");
delete DDR_MEM; DDR_MEM = 0;
$end;
$destruct_component("EPIT2");
delete EPIT2; EPIT2 = 0;
$end;
$destruct_component("USB_PHY1");
delete USB_PHY1; USB_PHY1 = 0;
$end;
$destruct_component("CORTEX_A9MP");
delete CORTEX_A9MP; CORTEX_A9MP = 0;
$end;
$destruct_component("GPIO1");
delete GPIO1; GPIO1 = 0;
$end;
$destruct_component("IPU1_br");
delete IPU1_br; IPU1_br = 0;
$end;
$destruct_component("ECSPI3");
delete ECSPI3; ECSPI3 = 0;
$end;
$destruct_component("AHB_BUS");
delete AHB_BUS; AHB_BUS = 0;
$end;
$destruct_component("sd_br3");
delete sd_br3; sd_br3 = 0;
$end;
$destruct_component("APBH_BUS");
delete APBH_BUS; APBH_BUS = 0;
$end;
$destruct_component("L2C_PL310");
delete L2C_PL310; L2C_PL310 = 0;
$end;
$destruct_component("I2C1");
delete I2C1; I2C1 = 0;
$end;
$destruct_component("SNVS");
delete SNVS; SNVS = 0;
$end;
$destruct_component("IPU1");
delete IPU1; IPU1 = 0;
$end;
$destruct_component("GPIO3");
delete GPIO3; GPIO3 = 0;
$end;
$destruct_component("EEPROM2");
delete EEPROM2; EEPROM2 = 0;
$end;
$destruct_component("IPU2_br");
delete IPU2_br; IPU2_br = 0;
$end;
$destruct_component("SDMA");
delete SDMA; SDMA = 0;
$end;
$destruct_component("HOST3_br");
delete HOST3_br; HOST3_br = 0;
$end;
$destruct_component("ENET");
delete ENET; ENET = 0;
$end;
$destruct_component("ECSPI1");
delete ECSPI1; ECSPI1 = 0;
$end;
$destruct_component("GPIO5");
delete GPIO5; GPIO5 = 0;
$end;
$destruct_component("AHB2APBH");
delete AHB2APBH; AHB2APBH = 0;
$end;
$destruct_component("SSI1");
delete SSI1; SSI1 = 0;
$end;
$destruct_component("I2C2");
delete I2C2; I2C2 = 0;
$end;
$destruct_component("IPU2");
delete IPU2; IPU2 = 0;
$end;
$destruct_component("sd_br1");
delete sd_br1; sd_br1 = 0;
$end;
$destruct_component("USB_PHY2");
delete USB_PHY2; USB_PHY2 = 0;
$end;
$destruct_component("uSDHC4");
delete uSDHC4; uSDHC4 = 0;
$end;
$destruct_component("GPIO7");
delete GPIO7; GPIO7 = 0;
$end;
$destruct_component("UART1");
delete UART1; UART1 = 0;
$end;
$destruct_component("FLASH");
delete FLASH; FLASH = 0;
$end;
$destruct_component("WDOG1");
delete WDOG1; WDOG1 = 0;
$end;
$destruct_component("SSI2");
delete SSI2; SSI2 = 0;
$end;
$destruct_component("I2C3");
delete I2C3; I2C3 = 0;
$end;
$destruct_component("UART3");
delete UART3; UART3 = 0;
$end;
$destruct_component("ROM");
delete ROM; ROM = 0;
$end;
$destruct_component("uSDHC2");
delete uSDHC2; uSDHC2 = 0;
$end;
$destruct_component("OCOTP_CTRL");
delete OCOTP_CTRL; OCOTP_CTRL = 0;
$end;
$destruct_component("SSI3");
delete SSI3; SSI3 = 0;
$end;
$destruct_component("UART5");
delete UART5; UART5 = 0;
$end;
$destruct_component("USB_PHY1_br");
delete USB_PHY1_br; USB_PHY1_br = 0;
$end;
$destruct_component("EPIT1");
delete EPIT1; EPIT1 = 0;
$end;
$destruct_component("USB_OTG");
delete USB_OTG; USB_OTG = 0;
$end;
$destruct_component("MMDC2");
delete MMDC2; MMDC2 = 0;
$end;
$destruct_component("ECSPI4");
delete ECSPI4; ECSPI4 = 0;
$end;
$destruct_component("AXI2AHB");
delete AXI2AHB; AXI2AHB = 0;
$end;
$destruct_component("sd_br4");
delete sd_br4; sd_br4 = 0;
$end;
$destruct_component("GPT");
delete GPT; GPT = 0;
$end;
$destruct_component("enet_br");
delete enet_br; enet_br = 0;
$end;
$destruct_component("GPC");
delete GPC; GPC = 0;
$end;
$destruct_component("SPDIF");
delete SPDIF; SPDIF = 0;
$end;
$destruct_component("GPIO2");
delete GPIO2; GPIO2 = 0;
$end;
$destruct_component("AUDMUX");
delete AUDMUX; AUDMUX = 0;
$end;
$destruct_component("USB_PHY2_br");
delete USB_PHY2_br; USB_PHY2_br = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$socket("GPIO0_IN1");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > GPIO0_IN1;
$end;
$socket("GPIO0_OUT0");
tlm::tlm_initiator_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > GPIO0_OUT0;
$end;
$socket("I2C1_Bus");
tlm::tlm_initiator_socket< 8U,i2c_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > I2C1_Bus;
$end;
$component("IP_BUS");
ip_bus_pvt *IP_BUS;
$end;
$component("AHB2IP");
ahb2ip_pvt *AHB2IP;
$end;
$component("USB_HOST1");
usb_host_pvt *USB_HOST1;
$end;
$component("ECSPI2");
i_mx6_ecspi_pvt *ECSPI2;
$end;
$component("USB_HOST2");
usb_host_pvt *USB_HOST2;
$end;
$component("USB_HOST3");
usb_host_pvt *USB_HOST3;
$end;
$component("PWM1");
i_mx6_pwm_pvt *PWM1;
$end;
$component("HOST2_br");
usb_br_pvt *HOST2_br;
$end;
$component("GPIO4");
i_mx6_gpio_pvt *GPIO4;
$end;
$component("sd_br2");
ahb2axi32_pvt *sd_br2;
$end;
$component("PCIe_br");
AXI2GENERIC_br_pvt *PCIe_br;
$end;
$component("GPIO6");
i_mx6_gpio_pvt *GPIO6;
$end;
$component("PWM2");
i_mx6_pwm_pvt *PWM2;
$end;
$component("OCRAM");
ocram_pvt *OCRAM;
$end;
$component("PCIe");
i_mx6_pcie_pvt *PCIe;
$end;
$component("AXI_BUS");
axi_bus_pvt *AXI_BUS;
$end;
$component("CCM");
i_mx6_ccm_pvt *CCM;
$end;
$component("UART2");
i_mx6_uart_pvt *UART2;
$end;
$component("uSDHC3");
i_mx6_usdhc_pvt *uSDHC3;
$end;
$component("HDMI_br");
hdmi_br_pvt *HDMI_br;
$end;
$component("PWM3");
i_mx6_pwm_pvt *PWM3;
$end;
$component("WDOG2");
i_mx6_wdog_pvt *WDOG2;
$end;
$component("USBNC");
USBNC_pvt *USBNC;
$end;
$component("IOMUXC");
i_mx6_iomuxc_pvt *IOMUXC;
$end;
$component("HDMI");
i_mx6_hdmi_pvt *HDMI;
$end;
$component("UART4");
i_mx6_uart_pvt *UART4;
$end;
$component("ASRC");
i_mx6_asrc_pvt *ASRC;
$end;
$component("SRC");
i_mx6_src_pvt *SRC;
$end;
$component("SATA_br");
AXI2AHP_br_pvt *SATA_br;
$end;
$component("uSDHC1");
i_mx6_usdhc_pvt *uSDHC1;
$end;
$component("PWM4");
i_mx6_pwm_pvt *PWM4;
$end;
$component("OTG_br");
usb_br_pvt *OTG_br;
$end;
$component("SATA");
i_mx6_sata_pvt *SATA;
$end;
$component("MMDC1");
i_mx6_mmdc_pvt *MMDC1;
$end;
$component("ECSPI5");
i_mx6_ecspi_pvt *ECSPI5;
$end;
$component("EXT_MEM");
ext_memory_pvt *EXT_MEM;
$end;
$component("DDR_MEM");
ddr_memory_pvt *DDR_MEM;
$end;
$component("EPIT2");
i_mx6_epit_pvt *EPIT2;
$end;
$component("USB_PHY1");
i_mx6_usbphy_pvt *USB_PHY1;
$end;
$component("CORTEX_A9MP");
Cortex_A9MP_pvt *CORTEX_A9MP;
$end;
$component("GPIO1");
i_mx6_gpio_pvt *GPIO1;
$end;
$component("IPU1_br");
IPU_br_pvt *IPU1_br;
$end;
$component("ECSPI3");
i_mx6_ecspi_pvt *ECSPI3;
$end;
$component("AHB_BUS");
ahb_bus_pvt *AHB_BUS;
$end;
$component("sd_br3");
ahb2axi32_pvt *sd_br3;
$end;
$component("APBH_BUS");
apbh_bus_pvt *APBH_BUS;
$end;
$component("L2C_PL310");
PL310_pvt *L2C_PL310;
$end;
$component("I2C1");
i_mx6_i2c_pvt *I2C1;
$end;
$component("SNVS");
i_mx6_snvs_pvt *SNVS;
$end;
$component("IPU1");
i_mx6_ipu_pvt *IPU1;
$end;
$component("GPIO3");
i_mx6_gpio_pvt *GPIO3;
$end;
$component("EEPROM2");
EEPROM_pvt *EEPROM2;
$end;
$component("IPU2_br");
IPU_br_pvt *IPU2_br;
$end;
$component("SDMA");
i_mx6_sdma_pvt *SDMA;
$end;
$component("HOST3_br");
usb_br_pvt *HOST3_br;
$end;
$component("ENET");
i_mx6_enet_pvt *ENET;
$end;
$component("ECSPI1");
i_mx6_ecspi_pvt *ECSPI1;
$end;
$component("GPIO5");
i_mx6_gpio_pvt *GPIO5;
$end;
$component("AHB2APBH");
i_mx6_AHB2APBH_pvt *AHB2APBH;
$end;
$component("SSI1");
i_mx6_ssi_pvt *SSI1;
$end;
$component("I2C2");
i_mx6_i2c_pvt *I2C2;
$end;
$component("IPU2");
i_mx6_ipu_pvt *IPU2;
$end;
$component("sd_br1");
ahb2axi32_pvt *sd_br1;
$end;
$component("USB_PHY2");
i_mx6_usbphy_pvt *USB_PHY2;
$end;
$component("uSDHC4");
i_mx6_usdhc_pvt *uSDHC4;
$end;
$component("GPIO7");
i_mx6_gpio_pvt *GPIO7;
$end;
$component("UART1");
i_mx6_uart_pvt *UART1;
$end;
$component("FLASH");
SPI_FLASH_pvt *FLASH;
$end;
$component("WDOG1");
i_mx6_wdog_pvt *WDOG1;
$end;
$component("SSI2");
i_mx6_ssi_pvt *SSI2;
$end;
$component("I2C3");
i_mx6_i2c_pvt *I2C3;
$end;
$component("UART3");
i_mx6_uart_pvt *UART3;
$end;
$component("ROM");
rom_pvt *ROM;
$end;
$component("uSDHC2");
i_mx6_usdhc_pvt *uSDHC2;
$end;
$component("OCOTP_CTRL");
i_mx6_ocotp_ctrl_pvt *OCOTP_CTRL;
$end;
$component("SSI3");
i_mx6_ssi_pvt *SSI3;
$end;
$component("UART5");
i_mx6_uart_pvt *UART5;
$end;
$component("USB_PHY1_br");
ip2apb_pvt *USB_PHY1_br;
$end;
$component("EPIT1");
i_mx6_epit_pvt *EPIT1;
$end;
$component("USB_OTG");
usb_otg_pvt *USB_OTG;
$end;
$component("MMDC2");
i_mx6_mmdc_pvt *MMDC2;
$end;
$component("ECSPI4");
i_mx6_ecspi_pvt *ECSPI4;
$end;
$component("AXI2AHB");
axi2ahb_pvt *AXI2AHB;
$end;
$component("sd_br4");
ahb2axi32_pvt *sd_br4;
$end;
$component("GPT");
i_mx6_gpt_pvt *GPT;
$end;
$component("enet_br");
ahb2axi32_pvt *enet_br;
$end;
$component("GPC");
i_mx6_gpc_pvt *GPC;
$end;
$component("SPDIF");
i_mx6_spdif_pvt *SPDIF;
$end;
$component("GPIO2");
i_mx6_gpio_pvt *GPIO2;
$end;
$component("AUDMUX");
i_mx6_audmux_pvt *AUDMUX;
$end;
$component("USB_PHY2_br");
ip2apb_pvt *USB_PHY2_br;
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

