#include "hwlib.h"

#define SOCKET_NAME "/tmp/9Lq7BNBnBycd6nxy.socket"

static void *virtual_base;

#define HW_REGS_BASE (ALT_STM_OFST)
#define HW_REGS_SPAN (0x04000000)
#define HW_REGS_MASK (HW_REGS_SPAN - 1)

#define USER_IO_DIR (0x01000000)
#define BIT_LED (0x01000000)
#define BUTTON_MASK (0x02000000)


