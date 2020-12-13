#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>

#include <alt_types.h>
#include <io.h>

#include "motor.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"


int main() {
    motor_t motor = (motor_t) PERIPHERAL_MOTOR_0_BASE;
    bool dir = true;
  
    motor_init(motor);
  
    while (1) {
      motor_en(motor);
      
      motor_dir(motor, dir);
  
      motor_vel(motor, 1);
      sleep(5);
  
      motor_vel(motor, 3);
      sleep(5);
  
      motor_halt(motor);
      sleep(1);
  
      dir = 1 - dir;
    }
  
    return 0;
}
