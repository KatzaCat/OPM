package render

import "core:fmt"
import "core:os"

import SDL "vendor:sdl3"

SDL_RENDERER_CREATION_ERROR :: -0x020001

@(private)
renderer: ^SDL.Renderer = {};

create_renderer :: proc(window: ^SDL.Window) {
  renderer = SDL.CreateRenderer(window, nil);
  if (renderer == nil) {
    fmt.eprint("FATAIL ERROR: Failed to creat renderer with error:\n\t%s", SDL.GetError());
    os.exit(SDL_RENDERER_CREATION_ERROR);
  }
}

destroy_renderer :: proc() {
  SDL.DestroyRenderer(renderer);
}

render_frame :: proc() {
  SDL.SetRenderDrawColor(renderer, 140, 190, 214, 255);
  SDL.RenderClear(renderer);

  SDL.RenderPresent(renderer);
}
