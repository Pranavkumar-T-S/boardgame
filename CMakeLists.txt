cmake_minimum_required(VERSION 3.16)
project(BoardGame LANGUAGES C CXX VERSION "1.0.0")

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add SDL3 subdirectory
add_subdirectory(dependency/SDL)

# Create the sample executable
add_executable(sample_window src/main.cpp)

# Link SDL3 library
target_link_libraries(sample_window PRIVATE SDL3::SDL3)

# Include SDL3 headers
target_include_directories(sample_window PRIVATE dependency/SDL/include)

# Platform-specific settings
if(WIN32)
    # On Windows, link against main library to avoid console window
    target_link_libraries(sample_window PRIVATE SDL3::SDL3main)
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
