#include "screen.h"

int
get_screen_offset(int col, int row)
{
  return 0;
}

int
get_cursor()
{
  return 0;
}

int
handle_scrolling(int offset)
{
  return 0;
}

void
set_cursor()
{
}

/* Print a char on the screen at col:row or at cursor position */
void
print_char(char character, int col, int row, char attribute_byte)
{
  /* Create a byte (char) pointer to the start of the video memory */
  unsigned char* vidmem = (unsigned char*)VIDEO_ADDRESS;

  if (!attribute_byte) {
    attribute_byte = WHITE_ON_BLACK;
  }

  /* Get the video-memory offset for the on-screen location */
  int offset;
  /* If col and row are non-negative, use them for offset */
  if (col >= 0 && row >= 0) {
    offset = get_screen_offset(col, row);
    /* Otherwise use the current cursor position */
  } else {
    offset = get_cursor();
  }
  /* If newline character encountered, proceed to the end of the current row,
     so that it will be advanced to the first character of the current row */
  if (character == '\n') {
    int rows = offset / (2 * MAX_COLS);
    offset = get_screen_offset(79, rows);
    /* Otherwise write the character and its attribute byte to
       video memory at out calculated offset */
  } else {
    vidmem[offset] = character;
    vidmem[offset + 1] = attribute_byte;
  }

  /* Update the offset to the next character cell, which is two bytes
     ahead of the current character cell */
  offset += 2;
  /* Make scrolling adjustment for when we reach the bottom of the screen */
  offset = handle_scrolling(offset);
  /* Update the cursor position on the screen device */
  set_cursor(offset);
}
