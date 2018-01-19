
/*
 * Frambuffers contain 2-byte cells in an (25x80 matrix) where each cell in
 * encoded thus
 *
 * Bit     | 15 14 13 12 11 10 9 8 | 7 6 5 4 | 3 2 1 0 |
 * Content | Ascii                 | Fg      | Bg      |
 *
 */

/*
 * Text mode colour constants
 */

#include "framebuffer.h"
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

static const size_t ROWS = 25;
static const size_t COLUMNS = 80;

uint8_t
vga_cell_colour(enum vga_colour fg, enum vga_colour bg)
{
  return (fg << 4) | bg;
}

uint16_t
vga_entry(unsigned char c, uint8_t colour)
{
  return (uint16_t)c << 8 | colour;
}

uint16_t
populate_visible_screen(uint8_t c, enum vga_colour col)
{
  uint16_t** vid_mem = (uint16_t**)0xb8000;
  for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLUMNS; j++) {
      vid_mem[i][j] = c;
    }
  }
  return 0;
}
