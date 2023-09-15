CC    = gcc
CFLAGS = -O2 -Wall
LDFLAGS = -lpthread

default: all

all: ppurge

ppurge: ppurge.c 
	$(CC) $(CFLAGS) $(LDFLAGS) -o ppurge ppurge.c

install:
	chown root ppurge
	chmod 4755 ppurge 
