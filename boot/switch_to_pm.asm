[bits 16]

switch_to_pm:
  ; Switch off interrupts until we set up the protected mode,
  cli                           ; interrupt vector, or face destruction.

  lgdt [gdt_descriptor]         ; Load the global descriptor table, which defines
  ; the protected mode segments (e.g. for code and data)

  mov eax, cr0                  ; To make the switch to protected mode, we set
  or eax, 0x1                   ; the first bit of CR0, a control register
  mov cr0, eax

  jmp CODE_SEG:init_pm          ; Make a far jump (i.e. to a far away segment) to our 32-bit code
  ; this also forces our cpu to flush it's cache of pre-fetched and real mode
  ; decoded instructions, which can cause havoc otherwise.


[bits 32]
; initialise registers and the stack once in PM
init_pm:
  mov ax, DATA_SEG              ; in PM our old segments are meaningless
  mov ds, ax                    ; so we point our segment registers to the
  mov ss, ax                    ; data selector we defined in our GDT
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000              ; Update the stack pointer so that it is right at the top
  mov esp, ebp                  ; of our free space

  call BEGIN_PM                 ; Finally, call some well known label
