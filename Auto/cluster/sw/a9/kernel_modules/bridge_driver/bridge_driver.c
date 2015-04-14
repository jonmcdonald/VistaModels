
#include <linux/init.h>
#include <linux/module.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/ioport.h>
#include <linux/io.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <asm/uaccess.h>


/* Hardware Register definitions */
#define BRIDGE_BASE   0x10026000
#define BRIDGE_SIZE   0x1000
#define BRIDGE_STATUS 0x0

static void* bridge_virt = 0;

static struct proc_dir_entry* bridge_file;

static int 
bridge_show(struct seq_file *m, void *v)
{
//       	iowrite32(0b100, bridge_virt + BRIDGE_STATUS);
     seq_printf(m, "speed\n");

     return 0;
}

static int
bridge_open(struct inode *inode, struct file *file)
{
    return single_open(file, bridge_show, NULL);
}

static const struct file_operations bridge_fops = {
     .owner	= THIS_MODULE,
     .open	= bridge_open,
     .read	= seq_read,
     .llseek	= seq_lseek,
     .release	= single_release,
};

static int __init
bridge_init(void)
{
	bridge_file = proc_create("bridge", 0, NULL, &bridge_fops);
	if (!bridge_file) {
		return -ENOMEM;
	}

        bridge_virt = ioremap(BRIDGE_BASE, BRIDGE_SIZE);

	return 0;
}

module_init(bridge_init);

static void __exit
bridge_exit(void)
{
        iounmap(bridge_virt);
	proc_remove(bridge_file);
}

module_exit(bridge_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("\"bridge\" minimal module");
MODULE_VERSION("proc");

