#include "entrega5.h"
#include "hwlib.h"
#include "socal/alt_gpio.h"
#include "socal/hps.h"
#include "socal/socal.h"
#include <fcntl.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

static void led_on() { // Force function inlining
    alt_setbits_word((virtual_base + ((uint32_t)(ALT_GPIO1_SWPORTA_DR_ADDR) &
                                                  (uint32_t)(HW_REGS_MASK))),
                     BIT_LED);
}

static void led_off() { // Force function inlining
    alt_clrbits_word((virtual_base + ((uint32_t)(ALT_GPIO1_SWPORTA_DR_ADDR) &
                                                  (uint32_t)(HW_REGS_MASK))),
                     BIT_LED);
}

int main(int argc, char *argv[]) {
    // map the address space for the LED registers into user space so we can interact with them.
    // we'll actually map in the entire CSR span of the HPS since we want to access various
    // registers within that span
    int memfd = open("/dev/mem", (O_RDWR | O_SYNC));
    if (memfd == -1) {
        printf("ERROR: could not open \"/dev/mem\"...\n");
        return 1;
    }

    virtual_base = mmap(
	NULL,
	HW_REGS_SPAN,
	(PROT_READ | PROT_WRITE),
	MAP_SHARED,
	memfd,
	HW_REGS_BASE
    );

    if (virtual_base == MAP_FAILED) {
        printf("ERROR: mmap() failed...\n");
        close(memfd);
        return 1;
    }
    // initialize the pio controller
    // led: set the direction of the HPS GPIO1 bits attached to LEDs to output
    alt_setbits_word(
        (virtual_base + ((uint32_t)(ALT_GPIO1_SWPORTA_DDR_ADDR) & (uint32_t)(HW_REGS_MASK))),
        USER_IO_DIR);

    char sendBuff[1025] = { 0 };
    char recvBuff[1025] = { 0 };

    unlink(SOCKET_NAME);

    int sock = socket(AF_UNIX, SOCK_STREAM, 0);

    const struct sockaddr_un name = {.sun_family = AF_UNIX, .sun_path = SOCKET_NAME };
    bind(sock, (const struct sockaddr*)&name, sizeof(struct sockaddr_un));

    /* Prepare for accepting connections. */
    listen(sock, 100); // 100 is the backlog
    int sockfd = accept(sock, (struct sockaddr *)NULL, NULL);

    while (true) {
        const int n = read(sockfd, recvBuff, sizeof(recvBuff));
        if (n > 0) {
            recvBuff[n] = '\0';
	    switch (*recvBuff) {
		case '1':
			led_on();
			printf("on\n");
			break;
		case '0':
			led_off();
			printf("off\n");
			break;
		case '2':;
			uint32_t scan_input = alt_read_word(
			    (virtual_base + ((uint32_t)(ALT_GPIO1_EXT_PORTA_ADDR) & (uint32_t)(HW_REGS_MASK))));
			char str[80];
			sprintf(str, "%d \r\n", ~scan_input & BUTTON_MASK);
			printf("Button: %s", str);
			snprintf(sendBuff, sizeof(sendBuff), str);
			write(sockfd, sendBuff, strlen(sendBuff));
			break;

	    }

        }

	// uint32_t scan_input = alt_read_word(
        //     (virtual_base + ((uint32_t)(ALT_GPIO1_EXT_PORTA_ADDR) & (uint32_t)(HW_REGS_MASK))));
        // char str[80];
        // sprintf(str, "%d \r\n", ~scan_input & BUTTON_MASK);
        // printf("C: %s", str);
        // snprintf(sendBuff, sizeof(sendBuff), str);
        // write(sockfd, sendBuff, strlen(sendBuff));
        // sleep(6);
    }

    // clean up our memory mapping and exit
    if (munmap(virtual_base, HW_REGS_SPAN) != 0) {
        printf("ERROR: munmap() failed...\n");
        close(memfd);
        close(sockfd);
        return 1;
    }
    close(memfd);
    close(sockfd);
    sleep(1);
    return 0;
}

