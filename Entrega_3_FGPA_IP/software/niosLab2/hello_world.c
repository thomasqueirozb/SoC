/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

//#include <stdio.h>
//
//int main()
//{
//  printf("Hello from Nios II!\n");
//
//  return 0;
//}


#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>

#include <alt_types.h>
#include <io.h>

#include "system.h"
#include "altera_avalon_pio_regs.h"


static volatile int edge_capture;

volatile unsigned char vel = 0;
volatile bool on = 0;
volatile bool direction = 0;



//void handle_button_interrupts(void *context, alt_u32 id) {
//    /* Cast context to edge_capture's type. It is important that this be
//      * declared volatile to avoid unwanted compiler optimization.
//      */
//    volatile int *edge_capture_ptr = (volatile int *)context;
//    /* Store the value in the Button's edge capture register in *context. */
//    *edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(PIO_1_BASE);
//
//
//
//    /* Reset the Button's edge capture register. */
//    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_1_BASE, 0);
//}

int main() {
    unsigned int phases = 0;
    unsigned int led = 0;

    printf("Embarcados++\n");
//
//    /* Enable first four interrupts. */
//    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(PIO_1_BASE, 0xf);
//    /* Reset the edge capture register. */
//    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_1_BASE, 0x0);
//    /* Register the interrupt handler. */
//    alt_irq_register(PIO_1_IRQ, (void *)&edge_capture, handle_button_interrupts);


    while (true) {
        // sw is a bitmask
        const int sw = IORD_ALTERA_AVALON_PIO_DATA(PIO_1_BASE);

        on = sw & 1; // bit 1
        printf("on %d\n", (int) on);

        direction = (sw >> 1) & 1; // bit 2
        printf("direction %d\n", (int) direction);

        // vel = bit 2 + bit3 * 2
        vel = ((sw >> 2) & 1) + ((sw >> 3) & 1) * 2;
        printf("vel %d\n", (int) vel);

        if (on) {
        	phases = (phases + 1) % 6;
        	led = (led + 1) % 6;

        	if (direction) {
				IOWR_32DIRECT(PIO_2_BASE, 0, 0x08 >> phases);
				IOWR_32DIRECT(PIO_0_BASE, 0, 0x08 >> led);
			} else {
				IOWR_32DIRECT(PIO_2_BASE, 0, 0x01 << phases);
				IOWR_32DIRECT(PIO_0_BASE, 0, 0x01 << led);
			}
        }
		usleep(100000 / (vel + 1));
    };

    return 0;
}
