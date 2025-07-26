# SDL Sample Window Project

A simple SDL3-based application that demonstrates creating a window with animated rectangles.

## Features

- Creates an 800x600 SDL window
- Displays a bouncing red rectangle with animation
- Shows a static green rectangle in the center
- Cross-platform support (Windows, macOS, Linux)
- Modern CMake build system with Makefile wrapper

## Prerequisites

- CMake 3.16 or higher
- C++17 compatible compiler
- Make (for using the Makefile)

## Building

### Using Makefile (Recommended)

```bash
# Build the project
make

# Or explicitly build
make build

# Clean and rebuild
make rebuild

# Build debug version
make debug

# Show all available targets
make help
```

### Using CMake directly

```bash
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release
```

## Running

### Using Makefile

```bash
make run
```

### Manual execution

```bash
cd build/bin
./sample_window
```

## Controls

- **ESC** or close window to exit
- Watch the red rectangle bounce around the window!

## Project Structure

```
boardgame/
├── CMakeLists.txt          # Main CMake configuration
├── Makefile               # Build automation
├── README.md              # This file
├── build.sh               # Legacy build script (deprecated)
├── src/
│   └── main.cpp           # Main application source
└── dependency/
    └── SDL/               # SDL3 library (git submodule)
```

## Dependencies

The project uses SDL3 as a git submodule located in `dependency/SDL`. The CMake configuration automatically builds SDL3 as part of the project.

## Development

### Adding Features

1. Edit `src/main.cpp` for application logic
2. Modify `CMakeLists.txt` for build configuration
3. Use `make` to build and test

### Debugging

```bash
# Build debug version
make debug

# Run with debugger (example with gdb)
cd build/bin
gdb ./sample_window
```

## Platform Notes

### Windows

- Requires Visual Studio or MinGW
- May need additional Windows SDK components

### macOS

- Requires Xcode command line tools
- Creates .app bundle automatically

### Linux

- Requires development packages for graphics libraries
- Install build essentials and SDL dependencies

## License

This sample project is provided for educational purposes. SDL3 is licensed under the zlib license.
