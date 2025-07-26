cmake_minimum_required(VERSION 3.16)
project(BoardGame LANGUAGES C CXX VERSION "1.0.0")

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Configure SDL3 to build as static library
set(SDL_SHARED OFF CACHE BOOL "Build SDL3 shared library" FORCE)
set(SDL_STATIC ON CACHE BOOL "Build SDL3 static library" FORCE)
set(SDL_TEST OFF CACHE BOOL "Build SDL3 test programs" FORCE)
set(SDL_EXAMPLES OFF CACHE BOOL "Build SDL3 example programs" FORCE)

# Add SDL3 subdirectory
add_subdirectory(dependency/SDL)

# Create the sample executable
add_executable(sample_window src/main.cpp)

# Link SDL3 library
target_link_libraries(sample_window PRIVATE SDL3::SDL3-static)

# Include SDL3 headers
target_include_directories(sample_window PRIVATE dependency/SDL/include)

# Platform-specific settings
if(WIN32)
    # On Windows, set subsystem to avoid console window
    set_target_properties(sample_window PROPERTIES
        WIN32_EXECUTABLE TRUE
    )
    # Link against additional Windows libraries if needed
    target_link_libraries(sample_window PRIVATE winmm)
elseif(APPLE)
    # On macOS, set up bundle properties
    set_target_properties(sample_window PROPERTIES
        MACOSX_BUNDLE TRUE
        MACOSX_BUNDLE_GUI_IDENTIFIER "com.example.sample_window"
        MACOSX_BUNDLE_BUNDLE_VERSION "1.0"
        MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0"
    )
endif()

# Set output directory
set_target_properties(sample_window PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)
