
#pragma once

extern void gic_init();

extern unsigned int gic_acknowledge_irq();

extern void gic_complete_irq(unsigned int irq);

extern void gic_assign_binary_point(unsigned int bpr);

extern void gic_set_priority_2_interrupt(unsigned int irq, unsigned char priority);

extern void gic_set_target_2_interrupt(unsigned int irq, unsigned char target_cpu);

extern unsigned char gic_get_priority_2_interrupt(unsigned int irq);

typedef void (IRQHandler)(void);

extern void gic_register_handler(int irq, IRQHandler* handler);

extern void do_irq();
extern void do_fiq();
