# Makefile for SDL Sample Window project

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m

# Project settings
PROJECT_NAME := sample_window
BUILD_DIR := build
BIN_DIR := $(BUILD_DIR)/bin

# Build type can be overridden: make BUILD_TYPE=Debug
BUILD_TYPE ?= Release

# Validate BUILD_TYPE
ifeq ($(filter $(BUILD_TYPE),Debug Release),)
    $(error BUILD_TYPE must be either 'Debug' or 'Release', got '$(BUILD_TYPE)')
endif

# Emscripten settings
EMSDK_DIR := deps/emsdk
EMSCRIPTEN_TOOLCHAIN := $(EMSDK_DIR)/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake

# Detect number of CPU cores for parallel builds
NPROCS := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

.PHONY: all build clean configure run help install rebuild debug release web web-serve web-clean web-debug

# Default target
all: build
	@printf "$(GREEN)Default build completed with BUILD_TYPE=$(BUILD_TYPE)$(NC)\n"

# Help target
help:
	@printf "$(YELLOW)SDL Sample Window Project - Available targets:$(NC)\n"
	@printf "  $(GREEN)all$(NC)       - Build the project (default)\n"
	@printf "  $(GREEN)build$(NC)     - Build the project\n"
	@printf "  $(GREEN)configure$(NC) - Configure CMake build\n"
	@printf "  $(GREEN)clean$(NC)     - Clean build directory\n"
	@printf "  $(GREEN)run$(NC)       - Build and run the sample\n"
	@printf "  $(GREEN)install$(NC)   - Install the project\n"
	@printf "  $(GREEN)help$(NC)      - Show this help message\n"
	@printf "\n"
	@printf "$(YELLOW)Build type variants (BUILD_TYPE=Release|Debug):$(NC)\n"
	@printf "  $(GREEN)debug$(NC)     - Build debug version\n"
	@printf "  $(GREEN)release$(NC)   - Build release version (default)\n"
	@printf "\n"
	@printf "$(YELLOW)WebAssembly/Emscripten targets:$(NC)\n"
	@printf "  $(GREEN)web$(NC)       - Build for WebAssembly using Emscripten\n"
	@printf "  $(GREEN)web-serve$(NC) - Build for web and start local server\n"
	@printf "  $(GREEN)web-clean$(NC) - Clean web build directory\n"
	@printf "  $(GREEN)web-debug$(NC) - Build WebAssembly debug version\n"
	@printf "\n"
	@printf "$(YELLOW)Examples:$(NC)\n"
	@printf "  $(GREEN)make BUILD_TYPE=Debug$(NC)     - Build native debug version\n"
	@printf "  $(GREEN)make web BUILD_TYPE=Debug$(NC) - Build WebAssembly debug version\n"
	@printf "  $(GREEN)make BUILD_TYPE=Release$(NC)   - Build native release version (default)\n"
	@printf "  $(GREEN)make web BUILD_TYPE=Release$(NC) - Build WebAssembly release version\n"
	@printf "\n"
	@printf "$(YELLOW)Current BUILD_TYPE: $(BUILD_TYPE)$(NC)\n"
	@printf "\n"
	@printf "$(YELLOW)Controls when running:$(NC)\n"
	@printf "  - $(GREEN)ESC$(NC) or close window to exit\n"
	@printf "  - Watch the red rectangle bounce around!\n"

# Create build directory and configure CMake
configure: 
	@printf "$(YELLOW)Creating build directory for $(BUILD_TYPE) build...$(NC)\n"
	@mkdir -p $(BUILD_DIR)
	@printf "$(YELLOW)Configuring with CMake ($(BUILD_TYPE))...$(NC)\n"
	@cd $(BUILD_DIR) && cmake .. -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)

# Build the project
build: configure
	@printf "$(YELLOW)Building $(PROJECT_NAME) ($(BUILD_TYPE))...$(NC)\n"
	@cd $(BUILD_DIR) && cmake --build . --config $(BUILD_TYPE) -j$(NPROCS)
	@printf "$(GREEN)$(BUILD_TYPE) build completed successfully!$(NC)\n"
	@printf "$(GREEN)Executable location: $(BIN_DIR)/$(PROJECT_NAME)$(NC)\n"

# Clean build directory
clean:
	@printf "$(YELLOW)Cleaning build directory...$(NC)\n"
	@rm -rf $(BUILD_DIR)
	@printf "$(GREEN)Clean completed!$(NC)\n"

# Run the sample
run: build
	@printf "$(YELLOW)Running $(PROJECT_NAME)...$(NC)\n"
	@cd $(BIN_DIR) && ./$(PROJECT_NAME)

# Install the project
install: build
	@printf "$(YELLOW)Installing $(PROJECT_NAME)...$(NC)\n"
	@cd $(BUILD_DIR) && cmake --install . --config $(BUILD_TYPE)
	@printf "$(GREEN)Installation completed!$(NC)\n"

# Rebuild from scratch
rebuild: clean build

# WebAssembly/Emscripten build
web:
	@if [ ! -d "$(EMSDK_DIR)" ]; then \
		printf "$(RED)Error: emsdk submodule not found.$(NC)\n"; \
		printf "$(YELLOW)Please run: git submodule update --init --recursive$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(YELLOW)Setting up Emscripten from submodule...$(NC)\n"
	@cd $(EMSDK_DIR) && ./emsdk install latest && ./emsdk activate latest
	@printf "$(YELLOW)Building for WebAssembly with Emscripten ($(BUILD_TYPE))...$(NC)\n"
	@mkdir -p $(BUILD_DIR)
	@cd $(BUILD_DIR) && \
		source ../$(EMSDK_DIR)/emsdk_env.sh && \
		emcmake cmake .. -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) && \
		emmake make -j$(NPROCS)
	@printf "$(GREEN)WebAssembly $(BUILD_TYPE) build completed!$(NC)\n"
	@printf "$(GREEN)Web files location: $(BIN_DIR)/$(NC)\n"
	@printf "$(YELLOW)To test, run: make web-serve$(NC)\n"

# Serve the web build locally
web-serve: web
	@printf "$(YELLOW)Starting local web server...$(NC)\n"
	@printf "$(GREEN)Open http://localhost:8000 in your browser$(NC)\n"
	@printf "$(YELLOW)Press Ctrl+C to stop the server$(NC)\n"
	@cd $(BIN_DIR) && python3 -m http.server 8000

# Clean web build
web-clean:
	@printf "$(YELLOW)Cleaning web build directory...$(NC)\n"
	@rm -rf $(BUILD_DIR)
	@printf "$(GREEN)Web build clean completed!$(NC)\n"

# WebAssembly debug build variant
web-debug:
	@printf "$(YELLOW)Building WebAssembly debug version (shortcut for web BUILD_TYPE=Debug)...$(NC)\n"
	@$(MAKE) web BUILD_TYPE=Debug

# Helper/shortcut targets
# Debug build variant
debug:
	@printf "$(YELLOW)Building debug version (shortcut for BUILD_TYPE=Debug)...$(NC)\n"
	@$(MAKE) BUILD_TYPE=Debug build

# Release build variant (default)
release:
	@printf "$(YELLOW)Building release version (shortcut for BUILD_TYPE=Release)...$(NC)\n"
	@$(MAKE) BUILD_TYPE=Release build
