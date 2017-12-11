
unsigned char
port_to_byte(unsigned short port)
{
  // a C-wrapper that reads a byte from the specified port
  // =a (return) value of 'a' means put AL register in variable RESULT
  // d (port) means load edx with result
  unsigned char result;
  __asm__("in %%dx, %%al" : "=a"(result) : "d"(port));
  return result;
}

void
port_byte_out(unsigned short port, unsigned char data)
{
  // "a" (data) means load EAX with data
  // "d" (port) means load EDX with port
  __asm__("in %%dx, %%ax" : "=a"(data) : "d"(port));
}

unsigned short
port_word_in(unsigned short port)
{
  unsigned short result;
  __asm__("in %%dx, %%ax" : "=a"(result) : "d"(port));
  return result;
}

void
port_word_out(unsigned short port, unsigned short data)
{
  __asm__("out %%ax, %%dx" : "=a"(data) : "d"(port));
}
