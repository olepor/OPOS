#ifndef FRAMEBUFFER_H
#define FRAMEBUFFER_H
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

/* static const uint32_t initial_cell_address = 0xb8000; */

typedef enum vga_colour {
  VGA_COLOUR_BLACK = 0,
  VGA_COLOUR_BLUE = 1,
  VGA_COLOUR_GREEN = 2,
  VGA_COLOUR_CYAN = 3,
  VGA_COLOUR_RED = 4,
  VGA_COLOUR_MAGENTA = 5,
  VGA_COLOUR_BROWN = 6,
  VGA_COLOUR_LIGHT_GREY = 7,
  VGA_COLOUR_DARK_GREY = 8,
  VGA_COLOUR_LIGHT_BLUE = 9,
  VGA_COLOUR_LIGHT_GREEN = 10,
  VGA_COLOUR_LIGHT_CYAN = 11,
  VGA_COLOUR_LIGHT_RED = 12,
  VGA_COLOUR_LIGHT_MAGENTA = 13,
  VGA_COLOUR_LIGHT_BROWN = 14,
  VGA_COLOUR_WHITE = 15,
} vga_colour;

uint8_t vga_cell_colour(enum vga_colour fg, enum vga_colour bg);

uint16_t vga_entry(unsigned char c, uint8_t colour);

uint16_t populate_visible_screen(uint8_t c, enum vga_colour col);
#endif
