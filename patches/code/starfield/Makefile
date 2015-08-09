# Commands
CC = or1k-linux-musl-gcc
#CC = gcc
CPP = or1k-linux-musl-g++
OBJCOPY = or1k-linux-musl-objcopy
OBJDUMP = or1k-linux-musl-objdump
REMOVE = rm -rf
# Compiler flags
CFLAGS = -c -Wall -std=c99 -O3
# Linker flags
LDFLAGS =

# Sources
TARGET = main.c
SRC = $(TARGET)
SRC += starfield.c
SRC += fader.c

# Output filename
OUT = starfield

# Object defines
COBJ = $(SRC:.c=.o)

all: $(SRC) $(OUT) $(OUT).bin

$(OUT).bin: $(OUT)
	$(OBJCOPY) -O binary $< $@

$(OUT): $(COBJ) $(SOBJ)
	$(CC) $(LDFLAGS) $(COBJ) $(SOBJ) -o $@

$(COBJ) : %.o : %.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	$(REMOVE) $(COBJ) *~
