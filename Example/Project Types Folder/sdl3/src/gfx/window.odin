package gfx

import "core:fmt"
import "core:os"

import SDL "vendor:sdl3"

// erros
SDL_WINDOW_CREATION_ERROR :: -0x010001

// window information
WINDOW_TITLE :: "Window!";
WINDOW_WIDTH :: 1280;
WINDOW_HEIGHT :: 720;

@(private)
window: ^SDL.Window = {};

create_window :: proc() {
  window = SDL.CreateWindow(WINDOW_TITLE, WINDOW_WIDTH, WINDOW_HEIGHT, nil);
  if (window == nil) {
    fmt.eprint("FATAIL ERROR: Failed to creat window with error:\n\t%s", SDL.GetError());
    os.exit(SDL_WINDOW_CREATION_ERROR);
  }
}

destroy_window :: proc() {
  SDL.DestroyWindow(window);
}

get_window :: proc() -> ^SDL.Window {
  return window;
}