#!/usr/bin/make -f

PREFIX_BASE = $(strip $(dir $(realpath $(firstword $(MAKEFILE_LIST)))))

NAME_BUNDLE_DIR = AVR-GNU-Toolchain
NAME_BUNDLE_DIR_AMD64_WINDOWS = $(NAME_BUNDLE_DIR)-AMD64-Windows
BUNDLE_DIR = build/$(NAME_BUNDLE_DIR)
BUNDLE_DIR_AMD64_WINDOWS = build/$(NAME_BUNDLE_DIR_AMD64_WINDOWS)
PATH_BUNDLE_DIR_BIN = $(PREFIX_BASE)/$(BUNDLE_DIR)/bin
PATH_BUNDLE_DIR_AMD64_WINDOWS_BIN = $(PREFIX_BASE)/$(BUNDLE_DIR_AMD64_WINDOWS)/bin
TARGET_CHECK = test
NAME_PACK = $(NAME_BUNDLE_DIR).tar.xz
NAME_PACK_AMD64_WINDOWS = $(NAME_BUNDLE_DIR_AMD64_WINDOWS).7z
TARGET_PACK = build/$(NAME_PACK)
TARGET_PACK_AMD64_WINDOWS = build/$(NAME_PACK_AMD64_WINDOWS)

INSTALL_DIR_AVR_BINUTILS = build/AVR-Binutils
INSTALL_DIR_AVR_BINUTILS_AMD64_WINDOWS = $(INSTALL_DIR_AVR_BINUTILS)-AMD64-Windows
PREFIX_AVR_BINUTILS = $(PREFIX_BASE)/$(INSTALL_DIR_AVR_BINUTILS)
PREFIX_AVR_BINUTILS_AMD64_WINDOWS = $(PREFIX_BASE)/$(INSTALL_DIR_AVR_BINUTILS_AMD64_WINDOWS)
TARGET_BUNDLE_AVR_BINUTILS = $(BUNDLE_DIR)/bin/avr-as
TARGET_BUNDLE_AVR_BINUTILS_AMD64_WINDOWS = $(BUNDLE_DIR_AMD64_WINDOWS)/bin/avr-as.exe

INSTALL_DIR_AVR_GCC = build/AVR-GCC
INSTALL_DIR_AVR_GCC_AMD64_WINDOWS = $(INSTALL_DIR_AVR_GCC)-AMD64-Windows
PREFIX_AVR_GCC = $(PREFIX_BASE)/$(INSTALL_DIR_AVR_GCC)
PREFIX_AVR_GCC_AMD64_WINDOWS = $(PREFIX_BASE)/$(INSTALL_DIR_AVR_GCC_AMD64_WINDOWS)
TARGET_BUNDLE_AVR_GCC = $(BUNDLE_DIR)/bin/avr-gcc
TARGET_BUNDLE_AVR_GCC_AMD64_WINDOWS = $(BUNDLE_DIR_AMD64_WINDOWS)/bin/avr-gcc.exe

INSTALL_DIR_AVR_GDB = build/AVR-GDB
INSTALL_DIR_AVR_GDB_AMD64_WINDOWS = $(INSTALL_DIR_AVR_GDB)-AMD64-Windows
PREFIX_AVR_GDB = $(PREFIX_BASE)/$(INSTALL_DIR_AVR_GDB)
PREFIX_AVR_GDB_AMD64_WINDOWS = $(PREFIX_BASE)/$(INSTALL_DIR_AVR_GDB_AMD64_WINDOWS)
TARGET_BUNDLE_AVR_GDB = $(BUNDLE_DIR)/bin/avr-gdb
TARGET_BUNDLE_AVR_GDB_AMD64_WINDOWS = $(BUNDLE_DIR_AMD64_WINDOWS)/bin/avr-gdb.exe

INSTALL_DIR_AVR_LIBC = build/AVR-LibC
PREFIX_AVR_LIBC = $(PREFIX_BASE)/$(INSTALL_DIR_AVR_LIBC)
TARGET_BUNDLE_AVR_LIBC = $(BUNDLE_DIR)/avr/lib/libc.a
TARGET_BUNDLE_AVR_LIBC_AMD64_WINDOWS = $(BUNDLE_DIR_AMD64_WINDOWS)/avr/lib/libc.a

.DELETE_ON_ERROR:

.PHONY: all avr-gnu-toolchain avr-gnu-toolchain-amd64-windows
all: avr-gnu-toolchain avr-gnu-toolchain-amd64-windows
avr-gnu-toolchain: bundle-avr-binutils bundle-avr-gcc bundle-avr-gdb bundle-avr-libc
avr-gnu-toolchain-amd64-windows: bundle-avr-binutils-amd64-windows bundle-avr-gcc-amd64-windows bundle-avr-gdb-amd64-windows bundle-avr-libc-amd64-windows

# AVR Binutils
.PHONY: avr-binutils avr-binutils-amd64-windows bundle-avr-binutils bundle-avr-binutils-amd64-windows
avr-binutils: $(INSTALL_DIR_AVR_BINUTILS)
avr-binutils-amd64-windows: $(INSTALL_DIR_AVR_BINUTILS_AMD64_WINDOWS)
bundle-avr-binutils: $(TARGET_BUNDLE_AVR_BINUTILS)
bundle-avr-binutils-amd64-windows: $(TARGET_BUNDLE_AVR_BINUTILS_AMD64_WINDOWS)

$(INSTALL_DIR_AVR_BINUTILS):
	$(MAKE) -f Makefile.avr-binutils avr-binutils

$(INSTALL_DIR_AVR_BINUTILS_AMD64_WINDOWS):
	$(MAKE) -f Makefile.avr-binutils avr-binutils-amd64-windows

$(TARGET_BUNDLE_AVR_BINUTILS): $(INSTALL_DIR_AVR_BINUTILS)
	mkdir -p $(BUNDLE_DIR)
	cp -r $</* $(BUNDLE_DIR)/

$(TARGET_BUNDLE_AVR_BINUTILS_AMD64_WINDOWS): $(INSTALL_DIR_AVR_BINUTILS_AMD64_WINDOWS)
	mkdir -p $(BUNDLE_DIR_AMD64_WINDOWS)
	cp -r $</* $(BUNDLE_DIR_AMD64_WINDOWS)/

# AVR GCC
.PHONY: avr-gcc avr-gcc-amd64-windows bundle-avr-gcc bundle-avr-gcc-amd64-windows
avr-gcc: $(INSTALL_DIR_AVR_GCC)
avr-gcc-amd64-windows: $(INSTALL_DIR_AVR_GCC_AMD64_WINDOWS)
bundle-avr-gcc: $(TARGET_BUNDLE_AVR_GCC)
bundle-avr-gcc-amd64-windows: $(TARGET_BUNDLE_AVR_GCC_AMD64_WINDOWS)

$(INSTALL_DIR_AVR_GCC): export PATH := $(PATH):$(PATH_BUNDLE_DIR_BIN)
$(INSTALL_DIR_AVR_GCC): bundle-avr-binutils
	$(MAKE) -f Makefile.avr-gcc avr-gcc

$(INSTALL_DIR_AVR_GCC_AMD64_WINDOWS): export PATH := $(PATH):$(PATH_BUNDLE_DIR_BIN)
$(INSTALL_DIR_AVR_GCC_AMD64_WINDOWS): bundle-avr-binutils bundle-avr-gcc
	$(MAKE) -f Makefile.avr-gcc avr-gcc-amd64-windows

$(TARGET_BUNDLE_AVR_GCC): $(INSTALL_DIR_AVR_GCC)
	mkdir -p $(BUNDLE_DIR)
	cp -r $</* $(BUNDLE_DIR)/

$(TARGET_BUNDLE_AVR_GCC_AMD64_WINDOWS): $(INSTALL_DIR_AVR_GCC_AMD64_WINDOWS)
	mkdir -p $(BUNDLE_DIR_AMD64_WINDOWS)
	cp -r $</* $(BUNDLE_DIR_AMD64_WINDOWS)/

# AVR GDB
.PHONY: avr-gdb avr-gdb-amd64-windows bundle-avr-gdb bundle-avr-gdb-amd64-windows
avr-gdb: $(INSTALL_DIR_AVR_GDB)
avr-gdb-amd64-windows: $(INSTALL_DIR_AVR_GDB_AMD64_WINDOWS)
bundle-avr-gdb: $(TARGET_BUNDLE_AVR_GDB)
bundle-avr-gdb-amd64-windows: $(TARGET_BUNDLE_AVR_GDB_AMD64_WINDOWS)

$(INSTALL_DIR_AVR_GDB):
	$(MAKE) -f Makefile.avr-gdb avr-gdb

$(INSTALL_DIR_AVR_GDB_AMD64_WINDOWS):
	$(MAKE) -f Makefile.avr-gdb avr-gdb-amd64-windows

$(TARGET_BUNDLE_AVR_GDB): $(INSTALL_DIR_AVR_GDB)
	mkdir -p $(BUNDLE_DIR)
	cp -r $</* $(BUNDLE_DIR)/

$(TARGET_BUNDLE_AVR_GDB_AMD64_WINDOWS): $(INSTALL_DIR_AVR_GDB_AMD64_WINDOWS)
	mkdir -p $(BUNDLE_DIR_AMD64_WINDOWS)
	cp -r $</* $(BUNDLE_DIR_AMD64_WINDOWS)/

# AVR LibC
.PHONY: avr-libc bundle-avr-libc bundle-avr-libc-amd64-windows
avr-libc: $(INSTALL_DIR_AVR_LIBC)
bundle-avr-libc: $(TARGET_BUNDLE_AVR_LIBC)
bundle-avr-libc-amd64-windows: $(TARGET_BUNDLE_AVR_LIBC_AMD64_WINDOWS)

$(INSTALL_DIR_AVR_LIBC): export PATH := $(PATH):$(PATH_BUNDLE_DIR_BIN)
$(INSTALL_DIR_AVR_LIBC): bundle-avr-binutils bundle-avr-gcc
	$(MAKE) -f Makefile.avr-libc avr-libc

$(TARGET_BUNDLE_AVR_LIBC): $(INSTALL_DIR_AVR_LIBC)
	mkdir -p $(BUNDLE_DIR)
	cp -r $</* $(BUNDLE_DIR)/

$(TARGET_BUNDLE_AVR_LIBC_AMD64_WINDOWS): $(INSTALL_DIR_AVR_LIBC)
	mkdir -p $(BUNDLE_DIR_AMD64_WINDOWS)
	cp -r $</* $(BUNDLE_DIR_AMD64_WINDOWS)/

.PHONY: check-avr-gnu-toolchain check-avr-gnu-toolchain-amd64-windows
check-avr-gnu-toolchain: export PATH := $(PATH):$(PATH_BUNDLE_DIR_BIN)
check-avr-gnu-toolchain: $(TARGET_CHECK)
check-avr-gnu-toolchain-amd64-windows: export PATH := $(PATH):$(PATH_BUNDLE_DIR_AMD64_WINDOWS_BIN)
check-avr-gnu-toolchain-amd64-windows: $(TARGET_CHECK)

$(TARGET_CHECK):
	mkdir test
	cd test && git clone --branch=v8.0 --depth=1 https://github.com/Optiboot/optiboot.git
	cd test/optiboot/optiboot/bootloaders/optiboot && $(MAKE) atmega328

.PHONY: pack pack-avr-gnu-toolchain pack-avr-gnu-toolchain-amd64-windows
pack: pack-avr-gnu-toolchain pack-avr-gnu-toolchain-amd64-windows
pack-avr-gnu-toolchain: $(TARGET_PACK)
pack-avr-gnu-toolchain-amd64-windows: $(TARGET_PACK_AMD64_WINDOWS)

$(TARGET_PACK):
	cd build && XZ_OPT=-9 tar -ca --owner=0 --group=0 -f $(NAME_PACK) -C $(NAME_BUNDLE_DIR) .

$(TARGET_PACK_AMD64_WINDOWS):
	cd build && 7zz a -mx9 $(NAME_PACK_AMD64_WINDOWS) ./$(NAME_BUNDLE_DIR_AMD64_WINDOWS)/*

.PHONY: clean
clean:
	rm -rf build
