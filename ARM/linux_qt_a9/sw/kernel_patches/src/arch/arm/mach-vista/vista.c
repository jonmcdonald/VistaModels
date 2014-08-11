#include <linux/device.h>
#include <linux/amba/bus.h>
#include <linux/amba/mmci.h>
#include <linux/io.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/of_platform.h>
#include <linux/irqchip.h>
#include <asm/mach/arch.h>
#include <asm/mach/map.h>

static void __init vista_dt_init(void)
{
	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
}

static const char * const vista_board_dt_compat[] = {
	"mentor,vista",
	NULL,
};

DT_MACHINE_START(VISTA_DT, "Mentor Vista Cortex-A9 (Device Tree)")
	.init_machine	= vista_dt_init,
	.dt_compat	= vista_board_dt_compat,
MACHINE_END
