PREFIX ?= /usr/local

INCLUDE_DIR = $(PREFIX)/include/h2co3_hash_table/

all: hash_table.hh

install: all
	mkdir -p $(INCLUDE_DIR)
	cp hash_table.hh $(INCLUDE_DIR)

clean:

.PHONY: all install clean
