# Name: Makefile
# Author: David Caldwell <david@porkrind.org>
# Copyright: 2014 David Caldwell
# License: GPLv2+ (See LICENSE)

# This is a prototype Makefile. Modify it according to your needs.
# You should at least check the settings for
# DEVICE ....... The AVR device you compile for
# CLOCK ........ Target AVR clock rate in Hertz
# OBJECTS ...... The object files created from your source files. This list is
#                usually the same as the list of source files with suffix ".o".
# PROGRAMMER ... Options to avrdude which define the hardware you use for
#                uploading to the AVR and the interface where this hardware
#                is connected. We recommend that you leave it undefined and
#                add settings like this to your ~/.avrduderc file:
#                   default_programmer = "stk500v2"
#                   default_serial = "avrdoper"
# FUSES ........ Parameters for avrdude to flash the fuses appropriately.

DEVICE     = atmega328p
CLOCK      = 8000000
PROGRAMMER = -c avrisp2
FUSES      = -U hfuse:w:0xd9:m -U lfuse:w:0xa2:m

OBJECTS    = videogame-starter.o
PROGRAM    = videogame-starter

# For computing fuse byte values for other devices and options see
# the fuse bit calculator at http://www.engbedded.com/fusecalc/

# Tune the lines below only if you know what you are doing:

AVRDUDE = avrdude $(PROGRAMMER) -p $(DEVICE)
CC = avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -std=c99

# symbolic targets:
all:	$(PROGRAM).hex

$(PROGRAM): $(OBJECTS)

# .c.o:
# 	$(COMPILE) -c $< -o $@

# .S.o:
# 	$(COMPILE) -x assembler-with-cpp -c $< -o $@
# # "-x assembler-with-cpp" should not be necessary since this is the default
# # file type for the .S (with capital S) extension. However, upper case
# # characters are not always preserved on Windows. To ensure WinAVR
# # compatibility define the file type manually.

# .c.s:
# 	$(COMPILE) -S $< -o $@

flash:	all
	$(AVRDUDE) -U flash:w:$(PROGRAM).hex:i

fuse:
	$(AVRDUDE) $(FUSES)

# Xcode uses the Makefile targets "", "clean" and "install"
install: flash fuse

# if you use a bootloader, change the command below appropriately:
load: all
	bootloadHID $(PROGRAM).hex

clean:
	rm -f $(PROGRAM) $(PROGRAM).hex $(OBJECTS)

# file targets:
videogame-starter: $(OBJECTS)

%.hex: %
	rm -f $@
	avr-objcopy -j .text -j .data -O ihex $< $@
	avr-size --format=avr --mcu=$(DEVICE) $<
# If you have an EEPROM section, you must also create a hex file for the
# EEPROM and add it to the "flash" target.

# Targets for code debugging and analysis:
%.list: %
	avr-objdump -d $< > $@

%.E: %.c
	$(COMPILE) -E $<.c -o $@
