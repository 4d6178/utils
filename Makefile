# project name which will be used as a name of the resulting executable
PROJECT :=

SOURCE_EXTENSION := .cpp
HEADER_EXTENSION := .h

# some common directories
INCLUDE_DIR := include
SOURCE_DIR := src
OBJ_DIR := $(SOURCE_DIR)/obj
LIBRARY_DIR := lib
BIN_DIR := bin
BIN := $(BIN_DIR)/$(PROJECT)

# external include dirs
INCLUDE_DIRS :=

# compiler to use
CXX = clang++

# libraries to link with
LIB_NAMES :=
LIBS := $(addprefix -l, $(LIB_NAMES))

# path to the sources of gtest
GTEST_PATH :=

ifdef GTEST_PATH
	GTEST_INCLUDES := $(GTEST_PATH) $(GTEST_PATH)/src $(GTEST_PATH)/include
	INCLUDE_DIRS += $(GTEST_INCLUDES)

	# googletest requires pthreads
	LIBS += -lpthread
endif

# list of additional include directories
INCLUDES = $(addprefix -I, $(INCLUDE_DIRS) $(INCLUDE_DIR))

# compiter flags
CXXFLAGS = -Wall -Wextra -Werror -pedantic --std=c++11 $(INCLUDES)

# linker flags
LDFLAGS := $(LIBS)

# generate list of object files corresponding to source files
SOURCES = $(wildcard $(SOURCE_DIR)/*$(SOURCE_EXTENSION))
OBJECTS = $(addprefix $(OBJ_DIR)/, $(notdir $(SOURCES:$(SOURCE_EXTENSION)=.o)))

default: release

# mode-specific flags
.PHONY: debug
debug: CXXFLAGS += -g -O0 -DDEBUG
debug: LDFLAGS += -g
debug: build

.PHONY: release
release: CXXFLAGS += -O2 -DNDEBUG
release: build

# make compiler generate dependencies
# FIXME: seems that this doesn't work properly at the moment
-include Makefile.dep

Makefile.dep: $(SOURCES)
	$(CXX) $(CXXFLAGS) -MM $^ > $@

.PHONY: build
build: directories $(BIN)

# ensure that all required directories exist and build executable
.PHONY: directories
directories:
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(BIN_DIR)

# rule for object files
$(OBJ_DIR)/%.o: $(SOURCE_DIR)/%$(SOURCE_EXTENSION)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# rule for the resulting file
$(BIN): $(OBJECTS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@

# remove generated binaries
.PHONY: clean
clean:
	@rm -vrf $(BIN_DIR) $(OBJ_DIR) Makefile.dep
