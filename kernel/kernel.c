void some_func() {
  return;
}

int main(void) {
  char* vid_mem = (char*) 0xb8000; // the first byte in video memory
  *vid_mem = 'X';
  some_func();
}
