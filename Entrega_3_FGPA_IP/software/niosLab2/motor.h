#define motor_t unsigned int *

#include <io.h>


static void motor_init(motor_t motor) {
  IOWR_32DIRECT(motor, 0, 1);
}

static void motor_halt(motor_t motor) {
  IOWR_32DIRECT(motor, 0, 0);
}

static void motor_en(motor_t motor) {
  IOWR_32DIRECT(motor, 0, 1);
}

static void motor_dir(motor_t motor) {
  IOWR_32DIRECT(motor + 1, 0, dir);
}

static void motor_vel(motor_t motor){
  IOWR_32DIRECT(motor + 2, 0, vel);
}
