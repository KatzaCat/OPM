package main

import "core:fmt"
import "core:os"

import SDL "vendor:sdl3"

import "gfx"
import "gfx/render"

SDL_INITIATION_ERROR :: -0x000001

main :: proc() {
  if (!SDL.Init(SDL.INIT_VIDEO)) {
    fmt.eprintf("FATAIL ERROR: Failed to initiate SDL3 with error of:\n\t%s", SDL.GetError());
    os.exit(SDL_INITIATION_ERROR);
  }

  gfx.create_window();
  render.create_renderer(gfx.get_window());

  is_app_running: bool = true;
  for (is_app_running) {
    sdl_events: SDL.Event = {};
    for (SDL.PollEvent(&sdl_events)) {
      #partial switch (sdl_events.type) {
        case .QUIT:
          is_app_running = false;
      }
    }

    render.render_frame();
  }

  gfx.destroy_window();
  render.destroy_renderer();

  SDL.Quit();
}