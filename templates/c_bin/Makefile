# TODO: compile_commands.json
BIN_NAME     := project
SRC_PATH     := .
SOURCE_NAMES := main

SRC_EXT := c
CC ?= gcc

BUILD ?= release

VERSION_MAJ := 1
VERSION_MIN := 0
VERSION_PAT := 0

LIBS     :=
INCLUDES := -I $(SRC_PATH)

CFLAGS   ?= -std=c11 -Wall -Wextra -g
CPPFLAGS ?=
RCFLAGS  ?= -D NDEBUG
DCFLAGS  ?= -D DEBUG
LDFLAGS  ?=
RLDFLAGS ?=
DLDFLAGS ?=

DESTDIR        ?= 
INSTALL_PREFIX ?= /usr/local

# --------------------------------------------------

SOURCES  := $(SOURCE_NAMES:%=$(SRC_PATH)/%.$(SRC_EXT))
CPPFLAGS := $(INCLUDES)
CPPFLAGS += -D VERSION_MAJOR=$(VERSION_MAJ) \
			-D VERSION_MINOR=$(VERSION_MIN) \
			-D VERSION_PATCH=$(VERSION_PAT)

.SUFFIXES:
INSTALL := install
INSTALL_PROGRAM := $(INSTALL)
INSTALL_DATA := $(INSTALL) -m 644

LDLIBS :=
ifneq ($(LIBS),)
	CFLAGS  += $(shell pkg-config --cflags $(LIBS))
	LDLIBS  += $(shell pkg-config --libs-only-l $(LIBS))
	LDFLAGS += $(shell pkg-config --libs-only-L $(LIBS) --libs-only-other)
endif

release: export CFLAGS  := $(CFLAGS) $(RCFLAGS)
release: export LDFLAGS := $(LDFLAGS) $(RLDFLAGS)
debug:   export CFLAGS  := $(CFLAGS) $(DCFLAGS)
debug:   export LDFLAGS := $(LDFLAGS) $(DLDFLAGS)

release: export BUILD := release
debug:   export BUILD := debug

BIN_PATH   = bin/$(BUILD)
BUILD_PATH = build/$(BUILD)

export V := false
Q := $(if $(filter 1 true yes,$(V)),,@)

OBJECTS = $(SOURCES:$(SRC_PATH)/%.$(SRC_EXT)=$(BUILD_PATH)/%..o)
DEPS = $(OBJECTS:..o=.d)

.PHONY: release
release:
	@$(MAKE) all --no-print-directory

.PHONY: debug
debug:
	@$(MAKE) all --no-print-directory

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
	@ln -sf $(BIN_PATH)/$(BIN_NAME) $(BIN_NAME)

$(BIN_PATH)/$(BIN_NAME): $(OBJECTS)
	@mkdir -p $(dir $@)
	@echo "- Linking: $@..."
	$(Q)$(CC) $(OBJECTS) $(LDFLAGS) $(LDLIBS) -o $@

-include $(DEPS)

$(BUILD_PATH)/%..o: $(SRC_PATH)/%.$(SRC_EXT)
	@mkdir -p $(dir $@)
	@echo "- Compiling: $< -> $@..."
	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) $(INCLUDES) -MP -MMD -c $< -o $@
