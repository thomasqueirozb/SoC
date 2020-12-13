TARGET = hps_sock
ALT_DEVICE_FAMILY ?= soc_cv_av
SOCEDS_ROOT ?= $(SOCEDS_DEST_ROOT)
HWLIBS_ROOT = $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib
CROSS_COMPILE = arm-linux-gnueabihf-
CFLAGS = -g -Wall -D$(ALT_DEVICE_FAMILY) -I$(HWLIBS_ROOT)/include/$(ALT_DEVICE_FAMILY) -I$(HWLIBS_ROOT)/include/
LDFLAGS = -g -Wall
CC = $(CROSS_COMPILE)gcc
ARCH = arm
IP_TARGET=192.168.1.111

all: build deploy run

build: $(TARGET)

$(TARGET): entrega5.o 
	$(CC) $(LDFLAGS) $^ -o $@ 

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

run: 
	@sshpass -p root ssh -t root@$(IP_TARGET) "./$(TARGET) & python3 server.py"

deploy:
	scp $(TARGET) server.py root@$(IP_TARGET):/root 

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~
