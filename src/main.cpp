#include <SDL3/SDL.h>
#include <SDL3/SDL_main.h>
#include <iostream>

const int WINDOW_WIDTH = 800;
const int WINDOW_HEIGHT = 600;

int main(int argc, char *argv[]) {
  // Initialize SDL
  if (!SDL_Init(SDL_INIT_VIDEO)) {
    std::cerr << "SDL initialization failed: " << SDL_GetError() << std::endl;
    return 1;
  }

  // Create window
  SDL_Window *window =
      SDL_CreateWindow("SDL Sample Window with Rectangle", WINDOW_WIDTH,
                       WINDOW_HEIGHT, SDL_WINDOW_RESIZABLE);

  if (!window) {
    std::cerr << "Window creation failed: " << SDL_GetError() << std::endl;
    SDL_Quit();
    return 1;
  }

  // Create renderer
  SDL_Renderer *renderer = SDL_CreateRenderer(window, NULL);
  if (!renderer) {
    std::cerr << "Renderer creation failed: " << SDL_GetError() << std::endl;
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 1;
  }

  // Main loop flag
  bool running = true;
  SDL_Event event;

  // Animation variables
  float rectX = 50.0f;
  float rectY = 50.0f;
  float velocityX = 2.0f;
  float velocityY = 1.5f;
  const int rectWidth = 100;
  const int rectHeight = 80;

  std::cout << "SDL Window created successfully!" << std::endl;
  std::cout << "Press ESC to exit or close the window." << std::endl;

  // Main game loop
  while (running) {
    // Handle events
    while (SDL_PollEvent(&event)) {
      switch (event.type) {
      case SDL_EVENT_QUIT:
        running = false;
        break;
      case SDL_EVENT_KEY_DOWN:
        if (event.key.key == SDLK_ESCAPE) {
          running = false;
        }
        break;
      default:
        break;
      }
    }

    // Update rectangle position (bouncing animation)
    rectX += velocityX;
    rectY += velocityY;

    // Bounce off walls
    if (rectX <= 0 || rectX + rectWidth >= WINDOW_WIDTH) {
      velocityX = -velocityX;
    }
    if (rectY <= 0 || rectY + rectHeight >= WINDOW_HEIGHT) {
      velocityY = -velocityY;
    }

    // Clear screen with dark blue background
    SDL_SetRenderDrawColor(renderer, 30, 30, 60, 255);
    SDL_RenderClear(renderer);

    // Draw a bouncing rectangle (red)
    SDL_FRect rect = {rectX, rectY, (float)rectWidth, (float)rectHeight};
    SDL_SetRenderDrawColor(renderer, 255, 100, 100, 255);
    SDL_RenderFillRect(renderer, &rect);

    // Draw rectangle border (white)
    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
    SDL_RenderRect(renderer, &rect);

    // Draw a static rectangle in the center (green)
    SDL_FRect centerRect = {(WINDOW_WIDTH - 60) / 2.0f,
                            (WINDOW_HEIGHT - 60) / 2.0f, 60.0f, 60.0f};
    SDL_SetRenderDrawColor(renderer, 100, 255, 100, 255);
    SDL_RenderFillRect(renderer, &centerRect);

    // Draw center rectangle border (white)
    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
    SDL_RenderRect(renderer, &centerRect);

    // Present the rendered frame
    SDL_RenderPresent(renderer);

    // Small delay to control frame rate (roughly 60 FPS)
    SDL_Delay(16);
  }

  // Cleanup
  SDL_DestroyRenderer(renderer);
  SDL_DestroyWindow(window);
  SDL_Quit();

  std::cout << "SDL cleaned up successfully. Goodbye!" << std::endl;
  return 0;
}
