
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

#define PERIPHERAL_BASE   0x10026000
#define PERIPHERAL_SIZE   0x1000

#define PERIPHERAL_STATUS 0x0

#define PERIPHERAL_IRQ    35


static void* peripheral_virt = 0;

static struct proc_dir_entry* peripheral_file;


static irqreturn_t irq_handler(int irq, void *dev_id)
{
	iowrite32(0x0, peripheral_virt + PERIPHERAL_STATUS);
	return IRQ_HANDLED;
}


static int 
peripheral_show(struct seq_file *m, void *v)
{
     seq_printf(m, "peripheral driver, write value to /proc/peripheral to set status\nEg. echo \"101\" > /proc/peripheral\n");

     return 0;
}

static ssize_t
peripheral_write (struct file *file,
	   const char * buf, size_t size, loff_t * ppos)
{
  char mbuf[4];
  uint32_t status = 0;

  if (copy_from_user (mbuf, buf, 4))
    return -EFAULT;

  if(mbuf[0] == '1') {
    status |= (1 << 2);
  } 
  if(mbuf[1] == '1') {
    status |= (1 << 1);
  } 
  if(mbuf[2] == '1') {
    status |= (1 << 0);
  } 

  iowrite32(status, peripheral_virt + PERIPHERAL_STATUS);

  return 4;
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

	// Flash LED's to indicate initialisation
       	iowrite32(0b100, peripheral_virt + PERIPHERAL_STATUS);
	mdelay(50);
       	iowrite32(0b110, peripheral_virt + PERIPHERAL_STATUS);
	mdelay(50);
       	iowrite32(0b111, peripheral_virt + PERIPHERAL_STATUS);
	mdelay(50);
       	iowrite32(0, peripheral_virt + PERIPHERAL_STATUS);

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
       	iowrite32(0, peripheral_virt + PERIPHERAL_STATUS);
        iounmap(peripheral_virt);
	proc_remove(peripheral_file);
}

module_exit(peripheral_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("\"peripheral\" minimal module");
MODULE_VERSION("proc");

