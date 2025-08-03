# WebAssembly Development Guide

This guide explains how to build and develop the SDL3 sample for WebAssembly using Emscripten.

## Quick Start

1. **Setup Emscripten environment:**

   ```bash
   source ./scripts/setup-emscripten.sh
   ```

2. **Build for WebAssembly:**

   ```bash
   make web
   ```

3. **Test locally:**
   ```bash
   make web-serve
   # Open http://localhost:8000/sample_window.html
   ```

## Emscripten Configuration

The project is configured with the following Emscripten settings in `CMakeLists.txt`:

- **WASM=1**: Generate WebAssembly instead of asm.js
- **ALLOW_MEMORY_GROWTH=1**: Allow dynamic memory allocation
- **INITIAL_MEMORY=16777216**: Start with 16MB of memory
- **STACK_SIZE=1048576**: Use 1MB stack size
- **Custom HTML shell**: Located at `web/shell.html`

## File Structure

After building, the WebAssembly files are generated in `build-web/web/`:

```
build-web/web/
├── sample_window.html    # Main HTML page
├── sample_window.js      # JavaScript glue code
├── sample_window.wasm    # WebAssembly binary
└── sample_window.data    # Preloaded assets (if any)
```

## Development Tips

### Debugging

1. **Browser Console**: Check browser developer console for errors
2. **Emscripten Debugging**: Build with debug flags:
   ```bash
   make web BUILD_TYPE=Debug
   ```

### Performance

- The application targets 60 FPS using `SDL_Delay(16)`
- WebAssembly performance is typically 80-90% of native code
- Use browser performance tools to profile

### Memory Management

- Initial memory is set to 16MB
- Memory can grow dynamically if needed
- Monitor memory usage in browser dev tools

## Custom HTML Shell

The project uses a custom HTML shell (`web/shell.html`) that provides:

- Loading progress indicator
- Responsive design
- Game controls documentation
- Error handling

To modify the appearance, edit `web/shell.html`.

## Deployment

### GitHub Pages (Automatic)

The CI workflow automatically deploys to GitHub Pages when pushing to the main branch:

- Live demo: https://pranavkumar-t-s.github.io/boardgame/demo/sample_window.html

### Manual Deployment

1. Build WebAssembly version:

   ```bash
   make web
   ```

2. Upload contents of `build-web/web/` to your web server

3. Ensure proper MIME types:
   - `.wasm` files: `application/wasm`
   - `.js` files: `application/javascript`

## Troubleshooting

### Common Issues

1. **CORS errors**: Always serve from a web server, not file:// protocol
2. **Missing emsdk**: Run `git submodule update --init --recursive`
3. **Build failures**: Ensure Emscripten environment is properly sourced

### Browser Compatibility

- **Chrome/Chromium**: Full support
- **Firefox**: Full support
- **Safari**: Full support (iOS 11+)
- **Edge**: Full support

### Performance Issues

- Enable browser hardware acceleration
- Close other tabs/applications
- Use Release build type for better performance

## Advanced Configuration

To modify Emscripten build settings, edit the `EMSCRIPTEN` section in `CMakeLists.txt`:

```cmake
target_link_options(sample_window PRIVATE
    -sWASM=1
    -sALLOW_MEMORY_GROWTH=1
    # Add your custom flags here
)
```

Common flags:

- `-O3`: Maximum optimization
- `-sNO_EXIT_RUNTIME=1`: Keep runtime alive
- `-sEXPORTED_FUNCTIONS=_main,_custom_function`: Export additional functions
- `-sTOTAL_MEMORY=33554432`: Set fixed memory size (32MB)
