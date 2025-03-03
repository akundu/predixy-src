
.PHONY: all debug clean test install

# Detect platform and set make command
PLATFORM := $(shell uname)
MAKE := $(if $(filter $(PLATFORM),FreeBSD OpenBSD),gmake,make)

# Define output directory
BINDIR := bin

# Default target
all: create_dirs build

# Create necessary directories
create_dirs:
	@mkdir -p $(BINDIR)

# Build targets
build:
	@$(MAKE) -C src -f Makefile BINDIR=../$(BINDIR)

debug:
	@$(MAKE) -C src -f Makefile debug BINDIR=../$(BINDIR)

# Clean target
clean:
	@$(MAKE) -C src -f Makefile clean
	@rm -rf $(BINDIR)
	@echo "Cleaned $(BINDIR) directory"

# Test target
test:
	@python3 test/basic.py

# Install target
install:
	@mkdir -p $(DESTDIR)/usr/local/bin
	@cp $(BINDIR)/predixy $(DESTDIR)/usr/local/bin/
	@chmod 755 $(DESTDIR)/usr/local/bin/predixy
