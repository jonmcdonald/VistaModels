
#include <linux/init.h>
#include <linux/module.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/ioport.h>
#include <linux/io.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <asm/uaccess.h>
#include <linux/delay.h>
#include <linux/irq.h>
#include <linux/interrupt.h>

/* Hardware Register definitions */

#define PERIPHERAL_BASE   0x40000000
#define PERIPHERAL_SIZE   0x1000

#define GPIO_DATA_0 0x0
#define GPIO_TRI_0  0x4
#define GIER        0x11C
#define IP_IER      0x128
#define IP_ISR      0x120

#define PERIPHERAL_IRQ    61


static void* peripheral_virt = 0;

static struct proc_dir_entry* peripheral_file;


static irqreturn_t irq_handler(int irq, void *dev_id)
{
	unsigned int statusreg;
	unsigned int datareg;

	statusreg = ioread32(peripheral_virt + IP_ISR);
	if (statusreg & 0x1) {
	  datareg = ioread32(peripheral_virt + GPIO_DATA_0);
	  datareg >>= 4;
	  iowrite32(datareg, peripheral_virt + GPIO_DATA_0);
	  iowrite32(0x1, peripheral_virt + IP_ISR);
	}
	return IRQ_HANDLED;
}


static int 
peripheral_show(struct seq_file *m, void *v)
{
     seq_printf(m, "peripheral driver, write value to /proc/peripheral to set LEDs\nEg. echo \"1010\" > /proc/peripheral\n");

     return 0;
}

static ssize_t
peripheral_write (struct file *file,
	   const char * buf, size_t size, loff_t * ppos)
{
  char mbuf[5];
  uint32_t ledvals = 0;

  if (copy_from_user (mbuf, buf, 5))
    return -EFAULT;

  if(mbuf[3] == '1') {
    ledvals |= (1 << 3);
  } 
  if(mbuf[2] == '1') {
    ledvals |= (1 << 2);
  } 
  if(mbuf[1] == '1') {
    ledvals |= (1 << 1);
  } 
  if(mbuf[0] == '1') {
    ledvals |= 1;
  } 

  iowrite32(ledvals, peripheral_virt + GPIO_DATA_0);

  return 5;
}

static int
peripheral_open(struct inode *inode, struct file *file)
{
    return single_open(file, peripheral_show, NULL);
}

static const struct file_operations peripheral_fops = {
     .owner	= THIS_MODULE,
     .open	= peripheral_open,
     .read	= seq_read,
     .write     = peripheral_write,
     .llseek	= seq_lseek,
     .release	= single_release,
};

static int __init
peripheral_init(void)
{
	int ret;

	peripheral_file = proc_create("peripheral", 0, NULL, &peripheral_fops);
	if (!peripheral_file) {
		return -ENOMEM;
	}

        peripheral_virt = ioremap(PERIPHERAL_BASE, PERIPHERAL_SIZE);

	// Set LEDs initially off, on, on, off
	iowrite32(0xF0, peripheral_virt + GPIO_TRI_0);  // 0b11110000 = 4 bits input, 4 bits output
	iowrite32(0x06, peripheral_virt + GPIO_DATA_0); // 0b00000110 = initial led state
	iowrite32(0x80000000, peripheral_virt + GIER);  // enable interrupts
	iowrite32(0x1, peripheral_virt + IP_IER);       // channel 1 interrupt

	ret = request_irq(PERIPHERAL_IRQ, irq_handler, 0, "peripheral_irq", (void *)(irq_handler));
	if (ret < 0) {
		printk(KERN_ALERT "%s: request_irq failed with %d\n", __func__, ret);
		return 0;
	}
        irq_set_irq_type(PERIPHERAL_IRQ, IRQ_TYPE_EDGE_RISING);
		
	return 0;
}

module_init(peripheral_init);

static void __exit
peripheral_exit(void)
{
	free_irq(PERIPHERAL_IRQ, (void *)(irq_handler));
       	//iowrite32(0, peripheral_virt + PERIPHERAL_STATUS);
        iounmap(peripheral_virt);
	proc_remove(peripheral_file);
}

module_exit(peripheral_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("\"peripheral\" minimal module");
MODULE_VERSION("proc");

