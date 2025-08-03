#include <SDL3/SDL.h>
#include <SDL3/SDL_main.h>
#include <iostream>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

const int WINDOW_WIDTH = 800;
const int WINDOW_HEIGHT = 600;

// Global context for the application
struct AppContext {
  SDL_Window *window;
  SDL_Renderer *renderer;
  bool running;

  // Animation variables
  float rectX;
  float rectY;
  float velocityX;
  float velocityY;
  int rectWidth;
  int rectHeight;

  AppContext()
      : window(nullptr), renderer(nullptr), running(true), rectX(50.0f),
        rectY(50.0f), velocityX(2.0f), velocityY(1.5f), rectWidth(100),
        rectHeight(80) {}
};

// Global app context (needed for Emscripten callback)
AppContext g_app;

void gameUpdate() {
  SDL_Event event;

  // Handle events
  while (SDL_PollEvent(&event)) {
    switch (event.type) {
    case SDL_EVENT_QUIT:
      g_app.running = false;
      break;
    case SDL_EVENT_KEY_DOWN:
      if (event.key.key == SDLK_ESCAPE) {
        g_app.running = false;
      }
      break;
    default:
      break;
    }
  }

  // Update rectangle position (bouncing animation)
  g_app.rectX += g_app.velocityX;
  g_app.rectY += g_app.velocityY;

  // Bounce off walls
  if (g_app.rectX <= 0 || g_app.rectX + g_app.rectWidth >= WINDOW_WIDTH) {
    g_app.velocityX = -g_app.velocityX;
  }
  if (g_app.rectY <= 0 || g_app.rectY + g_app.rectHeight >= WINDOW_HEIGHT) {
    g_app.velocityY = -g_app.velocityY;
  }

  // Clear screen with dark blue background
  SDL_SetRenderDrawColor(g_app.renderer, 30, 30, 60, 255);
  SDL_RenderClear(g_app.renderer);

  // Draw a bouncing rectangle (red)
  SDL_FRect rect = {g_app.rectX, g_app.rectY, (float)g_app.rectWidth,
                    (float)g_app.rectHeight};
  SDL_SetRenderDrawColor(g_app.renderer, 255, 100, 100, 255);
  SDL_RenderFillRect(g_app.renderer, &rect);

  // Draw rectangle border (white)
  SDL_SetRenderDrawColor(g_app.renderer, 255, 255, 255, 255);
  SDL_RenderRect(g_app.renderer, &rect);

  // Draw a static rectangle in the center (green)
  SDL_FRect centerRect = {(WINDOW_WIDTH - 60) / 2.0f,
                          (WINDOW_HEIGHT - 60) / 2.0f, 60.0f, 60.0f};
  SDL_SetRenderDrawColor(g_app.renderer, 100, 255, 100, 255);
  SDL_RenderFillRect(g_app.renderer, &centerRect);

  // Draw center rectangle border (white)
  SDL_SetRenderDrawColor(g_app.renderer, 255, 255, 255, 255);
  SDL_RenderRect(g_app.renderer, &centerRect);

  // Present the rendered frame
  SDL_RenderPresent(g_app.renderer);

#ifndef __EMSCRIPTEN__
  // Only add delay for native builds (Emscripten handles timing)
  SDL_Delay(16);
#endif
}

#ifdef __EMSCRIPTEN__
void emscriptenMainLoop() {
  gameUpdate();

  // Stop the loop if running is false
  if (!g_app.running) {
    emscripten_cancel_main_loop();
  }
}
#endif

void runMainLoop() {
#ifdef __EMSCRIPTEN__
  // For Emscripten, use the browser's animation frame
  emscripten_set_main_loop(emscriptenMainLoop, 60, 1);
#else
  // For native builds, use traditional while loop
  while (g_app.running) {
    gameUpdate();
  }
#endif
}

int main(int argc, char *argv[]) {
  // Initialize SDL
  if (!SDL_Init(SDL_INIT_VIDEO)) {
    std::cerr << "SDL initialization failed: " << SDL_GetError() << std::endl;
    return 1;
  }

  // Create window
  g_app.window =
      SDL_CreateWindow("SDL Sample Window with Rectangle", WINDOW_WIDTH,
                       WINDOW_HEIGHT, SDL_WINDOW_RESIZABLE);

  if (!g_app.window) {
    std::cerr << "Window creation failed: " << SDL_GetError() << std::endl;
    SDL_Quit();
    return 1;
  }

  // Create renderer
  g_app.renderer = SDL_CreateRenderer(g_app.window, NULL);
  if (!g_app.renderer) {
    std::cerr << "Renderer creation failed: " << SDL_GetError() << std::endl;
    SDL_DestroyWindow(g_app.window);
    SDL_Quit();
    return 1;
  }

  std::cout << "SDL Window created successfully!" << std::endl;
  std::cout << "Press ESC to exit or close the window." << std::endl;

  // Start the main loop (different implementations for native vs Emscripten)
  runMainLoop();

#ifndef __EMSCRIPTEN__
  // Cleanup (for native builds - Emscripten handles this automatically)
  SDL_DestroyRenderer(g_app.renderer);
  SDL_DestroyWindow(g_app.window);
  SDL_Quit();

  std::cout << "SDL cleaned up successfully. Goodbye!" << std::endl;
#endif

  return 0;
}
