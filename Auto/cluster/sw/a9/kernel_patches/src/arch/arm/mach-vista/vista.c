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
#include <linux/io.h>
#include <linux/of_address.h>
#include <asm/smp_scu.h>
#include <asm/cacheflush.h>
#include <asm/smp_plat.h>
#include <linux/delay.h>

extern void vista_secondary_startup(void);

#define SYSCTRL_BASE   0x10025000
#define SYSCTRL_SIZE   0x1000
static void* sysctrl_virt = 0;

static void __init vista_dt_init(void)
{
	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
}

static const struct of_device_id vista_smp_dt_scu_match[] __initconst = {
	{ .compatible = "arm,cortex-a9-scu", },
	{}
};

static void __init vista_smp_dt_prepare_cpus(unsigned int max_cpus)
{
	struct device_node *scu = of_find_matching_node(NULL,
			vista_smp_dt_scu_match);

	if (scu) {
		scu_enable(of_iomap(scu, 0));
	}

        sysctrl_virt = ioremap(SYSCTRL_BASE, SYSCTRL_SIZE);

	/*
	 * Write the address of secondary startup into the
	 * system-wide flags register. The boot monitor waits
	 * until it receives a soft interrupt, and then the
	 * secondary CPU branches to this address.
	 */
       	iowrite32(virt_to_phys(vista_secondary_startup), sysctrl_virt);
}

static void write_pen_release(int val)
{
	pen_release = val;
	smp_wmb();
	sync_cache_w(&pen_release);
}

static DEFINE_SPINLOCK(boot_lock);

void vista_secondary_init(unsigned int cpu)
{
	/*
	 * let the primary processor know we're out of the
	 * pen, then head off into the C entry point
	 */
	write_pen_release(-1);

	/*
	 * Synchronise with the boot thread.
	 */
	spin_lock(&boot_lock);
	spin_unlock(&boot_lock);
}

int vista_boot_secondary(unsigned int cpu, struct task_struct *idle)
{
	unsigned long timeout;

	/*
	 * Set synchronisation state between this boot processor
	 * and the secondary one
	 */
	spin_lock(&boot_lock);

	/*
	 * This is really belt and braces; we hold unintended secondary
	 * CPUs in the holding pen until we're ready for them.  However,
	 * since we haven't sent them a soft interrupt, they shouldn't
	 * be there.
	 */
	write_pen_release(cpu_logical_map(cpu));

	/*
	 * Send the secondary CPU a soft interrupt, thereby causing
	 * the boot monitor to read the system wide flags register,
	 * and branch to the address found there.
	 */
	arch_send_wakeup_ipi_mask(cpumask_of(cpu));

	timeout = jiffies + (1 * HZ);
	while (time_before(jiffies, timeout)) {
		smp_rmb();
		if (pen_release == -1)
			break;

		udelay(10);
	}

	/*
	 * now the secondary core is starting up let it run its
	 * calibrations, then wait for it to finish
	 */
	spin_unlock(&boot_lock);

	return pen_release != -1 ? -ENOSYS : 0;
}

static const char * const vista_board_dt_compat[] = {
	"mentor,vista",
	NULL,
};

struct smp_operations __initdata vista_smp_dt_ops = {
	.smp_prepare_cpus	= vista_smp_dt_prepare_cpus,
	.smp_secondary_init	= vista_secondary_init,
	.smp_boot_secondary	= vista_boot_secondary,
};

DT_MACHINE_START(VISTA_DT, "Mentor Vista Cortex-A9 (Device Tree)")
	.init_machine	= vista_dt_init,
	.dt_compat	= vista_board_dt_compat,
	.smp		= smp_ops(vista_smp_dt_ops),
MACHINE_END
