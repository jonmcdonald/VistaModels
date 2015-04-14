
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
#define BRIDGE_REVS   0x0
#define BRIDGE_SPEED  0x4

static void* bridge_virt = 0;

static struct proc_dir_entry* bridge_revs_file;
static struct proc_dir_entry* bridge_speed_file;

static int 
bridge_revs_show(struct seq_file *m, void *v)
{
     uint32_t value = ioread32(bridge_virt + BRIDGE_REVS);
//     seq_printf(m, "revs %d\n", value);
     seq_write(m, (const void *) &value, 4);
     return 0;
}

static int 
bridge_speed_show(struct seq_file *m, void *v)
{
     uint32_t value = ioread32(bridge_virt + BRIDGE_SPEED);
//     seq_printf(m, "speed %d\n", value);
     seq_write(m, (const void *) &value, 4);
     return 0;
}

static int
bridge_revs_open(struct inode *inode, struct file *file)
{
    return single_open(file, bridge_revs_show, NULL);
}

static int
bridge_speed_open(struct inode *inode, struct file *file)
{
    return single_open(file, bridge_speed_show, NULL);
}


static const struct file_operations bridge_revs_fops = {
     .owner	= THIS_MODULE,
     .open	= bridge_revs_open,
     .read	= seq_read,
     .llseek	= seq_lseek,
     .release	= single_release,
};

static const struct file_operations bridge_speed_fops = {
     .owner	= THIS_MODULE,
     .open	= bridge_speed_open,
     .read	= seq_read,
     .llseek	= seq_lseek,
     .release	= single_release,
};

static int __init
bridge_init(void)
{
	bridge_revs_file = proc_create("bridge_revs", 0, NULL, &bridge_revs_fops);
	if (!bridge_revs_file) {
		return -ENOMEM;
	}
	bridge_speed_file = proc_create("bridge_speed", 0, NULL, &bridge_speed_fops);
	if (!bridge_speed_file) {
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
	proc_remove(bridge_revs_file);
	proc_remove(bridge_speed_file);
}

module_exit(bridge_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("\"bridge\" minimal module");
MODULE_VERSION("proc");

