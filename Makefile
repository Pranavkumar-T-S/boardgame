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
BUILD_TYPE := Release

# Detect number of CPU cores for parallel builds
NPROCS := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

.PHONY: all build clean configure run help install rebuild debug release

# Default target
all: build

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
	@printf "$(YELLOW)Controls when running:$(NC)\n"
	@printf "  - $(GREEN)ESC$(NC) or close window to exit\n"
	@printf "  - Watch the red rectangle bounce around!\n"

# Create build directory and configure CMake
configure: 
	@printf "$(YELLOW)Creating build directory...$(NC)\n"
	@mkdir -p $(BUILD_DIR)
	@printf "$(YELLOW)Configuring with CMake...$(NC)\n"
	@cd $(BUILD_DIR) && cmake .. -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)

# Build the project
build: configure
	@printf "$(YELLOW)Building $(PROJECT_NAME)...$(NC)\n"
	@cd $(BUILD_DIR) && cmake --build . --config $(BUILD_TYPE) -j$(NPROCS)
	@printf "$(GREEN)Build completed successfully!$(NC)\n"
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

# Debug build variant
debug:
	@$(MAKE) BUILD_TYPE=Debug build

# Release build variant (default)
release:
	@$(MAKE) BUILD_TYPE=Release build
