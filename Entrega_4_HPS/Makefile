IP_TARGET = 192.168.1.111
IP_LOCAL = $(shell ip r | grep -oP '(?<=src )[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
GDBSERVER_PORT = 1000

TARGET = hps_gpio
ALT_DEVICE_FAMILY ?= soc_cv_av
SOCEDS_ROOT ?= $(SOCEDS_DEST_ROOT)
HWLIBS_ROOT = $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib
CROSS_COMPILE = arm-linux-gnueabihf-
CFLAGS = -g -Wall   -D$(ALT_DEVICE_FAMILY) -I$(HWLIBS_ROOT)/include/$(ALT_DEVICE_FAMILY)   -I$(HWLIBS_ROOT)/include/
LDFLAGS =  -g -Wall 
CC = $(CROSS_COMPILE)gcc
ARCH= arm

build: $(TARGET)

$(TARGET): main.o 
	$(CC) $(LDFLAGS)   $^ -o $@ 

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~

.PHONY: deploy
deploy: build
	scp $(TARGET) root@$(IP_TARGET):/root


.PHONY: run
run: deploy
	ssh -tt root@$(IP_TARGET) "/home/root/$(TARGET)"


.PHONY: gdb
gdb: deploy
	ssh -tt root@$(IP_TARGET) gdbserver $(IP_LOCAL):$(GDBSERVER_PORT) $(TARGET) 1>/dev/null &
	(echo "target extended-remote $(IP_TARGET):$(GDBSERVER_PORT)"; cat -) | gdb-multiarch $(TARGET) 

kill:
	ssh root@$(IP_TARGET) "ps ax | awk '/$(TARGET)/ {print $$1}' | xargs kill"

