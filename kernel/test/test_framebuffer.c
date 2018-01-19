#include "../framebuffer.h"
#include "minunit.h"

int tests_run = 0;

static char*
test_vga_colour()
{
  mu_assert("error, vga_colour",
            vga_colour(VGA_COLOUR_GREEN, VGA_COLOUR_BLACK) == (1 << 5));
  return 0;
}

static char*
all_tests()
{
  mu_run_test(test_vga_colour);
  return 0;
}

int
main(void)
{
  char* result = all_tests();
  if (*result != 0) {
    // still cannot print xD
  } else {
    // all tests passed
  }
  // #tests run
  return 0;
}
