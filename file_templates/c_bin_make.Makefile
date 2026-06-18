BIN_NAME := project
SRC_PATH = .
SOURCE_NAMES = main

SRC_EXT = c
CC ?= gcc

LIBS =
INCLUDES = -I $(SRC_PATH)

VERSIONING_FLAGS = -D VERSION_MAJOR=1 -D VERSION_MINOR=0 -D VERSION_PATCH=0 -D VERSION_REVISION=a
COMPILE_FLAGS = -std=c11 -Wall -Wextra -g
RCOMPILE_FLAGS = -D NDEBUG
DCOMPILE_FLAGS = -D DEBUG
LINK_FLAGS =
RLINK_FLAGS =
DLINK_FLAGS =

DESTDIR = /
INSTALL_PREFIX = usr/local

# --------------------------------------------------

SOURCES = $(SOURCE_NAMES:%=$(SRC_PATH)/%.$(SRC_EXT))

.SUFFIXES:
INSTALL = install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

ifneq ($(LIBS),)
	COMPILE_FLAGS += $(shell pkg-config --cflags $(LIBS))
	LINK_FLAGS += $(shell pkg-config --libs $(LIBS))
endif

release: export CFLAGS := $(CFLAGS) $(COMPILE_FLAGS) $(RCOMPILE_FLAGS) $(VERSION_REVISION)
release: export LDFLAGS := $(LDFLAGS) $(LINK_FLAGS) $(RLINK_FLAGS) $(VERSION_REVISION)
debug: export CFLAGS := $(CFLAGS) $(COMPILE_FLAGS) $(DCOMPILE_FLAGS) $(VERSION_REVISION)
debug: export LDFLAGS := $(LDFLAGS) $(LINK_FLAGS) $(DLINK_FLAGS) $(VERSION_REVISION)

release: export BUILD_PATH := build/release
release: export BIN_PATH := bin/release
debug: export BUILD_PATH := build/debug
debug: export BIN_PATH := bin/debug
install: export BIN_PATH := bin/release

export V := false
export CMD_PREFIX := @
ifeq ($(V),true)
	CMD_PREFIX :=
endif

OBJECTS = $(SOURCES:$(SRC_PATH)/%.$(SRC_EXT)=$(BUILD_PATH)/%.o)
DEPS = $(OBJECTS:.o=.d)

.PHONY: release
release: dirs
	@$(MAKE) all --no-print-directory

.PHONY: debug
debug: dirs
	@$(MAKE) all --no-print-directory

.PHONY: dirs
dirs:
	@echo "- Creating directories..."
	@mkdir -p $(dir $(OBJECTS))
	@mkdir -p $(BIN_PATH)

.PHONY: install
install:
	@echo "- Installing to $(DESTDIR)$(INSTALL_PREFIX)/bin..."
	@$(INSTALL_PROGRAM) $(BIN_PATH)/$(BIN_NAME) $(DESTDIR)$(INSTALL_PREFIX)/bin

.PHONY: uninstall
uninstall:
	@echo "- Removing $(DESTDIR)$(INSTALL_PREFIX)/bin/$(BIN_NAME)..."
	@$(RM) $(DESTDIR)$(INSTALL_PREFIX)/bin/$(BIN_NAME)

.PHONY: clean
clean:
	@echo "- Deleting $(BIN_NAME) symlink..."
	@$(RM) $(BIN_NAME)
	@echo "- Deleting directories..."
	@$(RM) -r build
	@$(RM) -r bin

all: $(BIN_PATH)/$(BIN_NAME)
	@echo "- Making symlink: $(BIN_NAME) -> $<..."
	@$(RM) $(BIN_NAME)
	@ln -s $(BIN_PATH)/$(BIN_NAME) $(BIN_NAME)

$(BIN_PATH)/$(BIN_NAME): $(OBJECTS)
	@echo "- Linking: $@..."
	$(CMD_PREFIX)$(CC) $(OBJECTS) $(LDFLAGS) -o $@

-include $(DEPS)

$(BUILD_PATH)/%.o: $(SRC_PATH)/%.$(SRC_EXT)
	@echo "- Compiling: $< -> $@..."
	$(CMD_PREFIX)$(CC) $(CFLAGS) $(INCLUDES) -MP -MMD -c $< -o $@
