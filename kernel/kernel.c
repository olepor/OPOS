#include "framebuffer.h"
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

int
main(void)
{
  char* vid_mem = (char*)0xb8000; // the first byte in video memory
  uint8_t term_col = vga_cell_colour(VGA_COLOUR_GREEN, VGA_COLOUR_BLACK);
  if (term_col == (1 << 5)) {
    vid_mem[0] = 'Y';
    vid_mem[1] = 0x28;
  } else {
    *vid_mem = 'X';
  }
  populate_visible_screen('S', 0);
  /* uint16_t term_entry = vga_entry('Y', term_col); */
  /* *vid_mem = term_entry; */
  return 0; /* A-OK! */
}
