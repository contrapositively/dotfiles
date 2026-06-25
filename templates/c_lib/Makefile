# TODO: pkg-config
# TODO: testing framework
LIB_NAME     := project
SRC_PATH     := src
HEADER_PATH  := include
SOURCE_NAMES := project
HEADER_NAMES := project

BUILD         ?= release
LIB_BIN_TYPES ?= static shared

SRC_EXT    := c
HEADER_EXT := h

CC ?= gcc
AR ?= ar
ARFLAGS ?= rcs

LIB_VERSION_MAJ := 1
LIB_VERSION_MIN := 0
LIB_VERSION_PAT := 0
ABI_VERSION_MAJ := 1
ABI_VERSION_MIN := 0
ABI_VERSION_PAT := 0

LIBS :=
INCLUDES := -I $(SRC_PATH) -I $(HEADER_PATH)

CFLAGS        ?= -std=c11 -Wall -Wextra -g
CPPFLAGS      ?=
RCFLAGS       ?= -D NDEBUG
DCFLAGS       ?= -D DEBUG
LDFLAGS       ?=
RLDFLAGS      ?=
DLDFLAGS      ?=
STATIC_CFLAGS ?=
SHARED_CFLAGS ?= -fPIC -fvisibility=hidden

DESTDIR        ?= 
INSTALL_PREFIX ?= /usr/local

# --------------------------------------------------

LIB_PREFIX := lib

STATIC_LIB := $(LIB_PREFIX)$(LIB_NAME).a
SHARED_LIB := $(LIB_PREFIX)$(LIB_NAME).so.$(ABI_VERSION_MAJ).$(ABI_VERSION_MIN).$(ABI_VERSION_PAT)
SHARED_LIB_COMPAT := $(LIB_PREFIX)$(LIB_NAME).so.$(ABI_VERSION_MAJ)
SHARED_LIB_NOABI := $(LIB_PREFIX)$(LIB_NAME).so

SOURCES := $(SOURCE_NAMES:%=$(SRC_PATH)/%.$(SRC_EXT))
HEADERS := $(HEADER_NAMES:%=$(HEADER_PATH)/%.$(HEADER_EXT))
CPPFLAGS += $(INCLUDES)
CPPFLAGS += -D VERSION_MAJOR=$(LIB_VERSION_MAJ) \
			-D VERSION_MINOR=$(LIB_VERSION_MIN) \
			-D VERSION_PATCH=$(LIB_VERSION_PAT) \
			-D ABI_VERSION_MAJOR=$(ABI_VERSION_MAJ) \
			-D ABI_VERSION_MINOR=$(ABI_VERSION_MIN) \
			-D ABI_VERSION_PATCH=$(ABI_VERSION_PAT)

.SUFFIXES:
INSTALL := install
INSTALL_STATIC := $(INSTALL) -m 644
INSTALL_SHARED := $(INSTALL) -m 755

LDLIBS :=
ifneq ($(LIBS),)
	CFLAGS  += $(shell pkg-config --cflags $(LIBS))
	LDLIBS  += $(shell pkg-config --libs-only-l $(LIBS))
	LDFLAGS += $(shell pkg-config --libs-only-L $(LIBS) --libs-only-other)
endif


release: export CFLAGS  := $(CFLAGS) $(RCFLAGS)
debug:   export CFLAGS  := $(CFLAGS) $(DCFLAGS)
static:  export CFLAGS  := $(CFLAGS) $(STATIC_CFLAGS)
shared:  export CFLAGS  := $(CFLAGS) $(SHARED_CFLAGS)

release: export LDFLAGS := $(LDFLAGS) $(RLDFLAGS)
debug:   export LDFLAGS := $(LDFLAGS) $(DLDFLAGS)

release: export BUILD := release
debug:   export BUILD := debug

STATIC_BIN_PATH   = bin/static/$(BUILD)
STATIC_BUILD_PATH = build/static/$(BUILD)
SHARED_BIN_PATH   = bin/shared/$(BUILD)
SHARED_BUILD_PATH = build/shared/$(BUILD)

export V := false
Q := $(if $(filter 1 true yes,$(V)),,@)

STATIC_OBJECTS = $(SOURCES:$(SRC_PATH)/%.$(SRC_EXT)=$(STATIC_BUILD_PATH)/%..o)
SHARED_OBJECTS = $(SOURCES:$(SRC_PATH)/%.$(SRC_EXT)=$(SHARED_BUILD_PATH)/%..o)
DEPS = $(SHARED_OBJECTS:..o=.d) $(STATIC_OBJECTS:.$(OBJ_EXT)=.d)

.PHONY: release
release:
	@$(MAKE) all --no-print-directory

.PHONY: debug
debug:
	@$(MAKE) all --no-print-directory

.PHONY: install-static install-shared install-headers install
install-static:
	@echo "- Installing static lib to $(DESTDIR)$(INSTALL_PREFIX)/lib..."
	@$(INSTALL) -d $(DESTDIR)$(INSTALL_PREFIX)/lib
	@$(INSTALL_STATIC) \
		$(STATIC_BIN_PATH)/$(STATIC_LIB) \
		$(DESTDIR)$(INSTALL_PREFIX)/lib
install-shared:
	@echo "- Installing shared lib to $(DESTDIR)$(INSTALL_PREFIX)/lib..."
	@$(INSTALL) -d $(DESTDIR)$(INSTALL_PREFIX)/lib
	@$(INSTALL_SHARED) \
		$(SHARED_BIN_PATH)/$(SHARED_LIB) \
		$(DESTDIR)$(INSTALL_PREFIX)/lib
	@cd $(DESTDIR)$(INSTALL_PREFIX)/lib && \
		ln -sf $(SHARED_LIB) $(SHARED_LIB_COMPAT)
	@cd $(DESTDIR)$(INSTALL_PREFIX)/lib && \
		ln -sf $(SHARED_LIB_COMPAT) $(SHARED_LIB_NOABI)
	@echo "- Suggested to run 'sudo ldconfig' to update registry..."
install-headers:
ifeq ($(strip $(HEADERS)),)
	@true
else
	@echo "- Installing headers to $(DESTDIR)$(INSTALL_PREFIX)/include/$(LIB_NAME)..."
	@$(INSTALL) -d  $(DESTDIR)$(INSTALL_PREFIX)/include/$(LIB_NAME)
	@$(INSTALL) -m 644 $(HEADERS) $(DESTDIR)$(INSTALL_PREFIX)/include/$(LIB_NAME)/
endif
.PHONY: install
install: release install-static install-shared install-headers

.PHONY: uninstall
uninstall:
	@echo "- Removing $(DESTDIR)$(INSTALL_PREFIX)/lib/$(LIB_NAME)..."
	@$(RM) $(DESTDIR)$(INSTALL_PREFIX)/lib/$(STATIC_LIB)
	@$(RM) $(DESTDIR)$(INSTALL_PREFIX)/lib/$(SHARED_LIB)
	@$(RM) $(DESTDIR)$(INSTALL_PREFIX)/lib/$(SHARED_LIB_COMPAT)
	@$(RM) $(DESTDIR)$(INSTALL_PREFIX)/lib/$(SHARED_LIB_NOABI)
	@echo "- Removing $(DESTDIR)$(INSTALL_PREFIX)/include/$(LIB_NAME)..."
	@$(RM) -r $(DESTDIR)$(INSTALL_PREFIX)/include/$(LIB_NAME)

.PHONY: clean
clean:
	@echo "- Deleting directories..."
	@$(RM) -r build/ bin/


.PHONY: static
static: $(STATIC_BIN_PATH)/$(STATIC_LIB)
$(STATIC_BIN_PATH)/$(STATIC_LIB): $(STATIC_OBJECTS)
	@mkdir -p $(dir $@)
	@echo "- Archiving: $@..."
	$(Q)$(AR) $(ARFLAGS) $@ $(STATIC_OBJECTS)

.PHONY: shared
shared: $(SHARED_BIN_PATH)/$(SHARED_LIB)
$(SHARED_BIN_PATH)/$(SHARED_LIB): $(SHARED_OBJECTS)
	@mkdir -p $(dir $@)
	@echo "- Linking: $@..."
	$(Q)$(CC) $(SHARED_OBJECTS) $(LDFLAGS) $(LDLIBS) -shared -o $@ \
		-Wl,-soname,$(SHARED_LIB_COMPAT)
	@cd $(SHARED_BIN_PATH) && ln -sf $(SHARED_LIB) $(SHARED_LIB_COMPAT)
	@cd $(SHARED_BIN_PATH) && ln -sf $(SHARED_LIB_COMPAT) $(SHARED_LIB_NOABI)


all: $(LIB_BIN_TYPES)


-include $(DEPS)

$(STATIC_BUILD_PATH)/%..o: $(SRC_PATH)/%.$(SRC_EXT)
	@mkdir -p $(dir $@)
	@echo "- Compiling (static): $< -> $@..."
	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) $(INCLUDES) -MP -MMD -c $< -o $@

$(SHARED_BUILD_PATH)/%..o: $(SRC_PATH)/%.$(SRC_EXT)
	@mkdir -p $(dir $@)
	@echo "- Compiling (shared): $< -> $@..."
	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) $(INCLUDES) -MP -MMD -c $< -o $@
