  ;;
  ;; A simple boot-sector program that loops forever
  ;;
[org 0x7c00]                    ; tell the assembler where this code will be loaded

  mov bp, 0x9000                ; set up the stack
  mov sp, bp

  mov bx, MSG_REAL_MODE
  call print_string

  call switch_to_pm             ; Note that we never return from here

  jmp $                         ; hang

%include "./print/print_string.asm"
%include "./print/print_string_pm.asm"
%include "./hex/print_hex.asm"
%include "gdt.asm"
%include "switch_to_pm.asm"

  [bits 32]

  ; Arrive here after switching to protected mode
BEGIN_PM:

  mov ebx, MSG_PROT_MODE
  call print_string_pm          ; use our 32-bit print routine

  jmp $                         ; hang

  ; Global variables
MSG_REAL_MODE db "Started in 16-bit real-mode", 0
  MSG_PROT_MODE db "Successfully landed in 32-bit protected mode", 0


  ; Boot-sector padding
times 510 - ($ - $$) db 0       ; pad the boot-sector with zeros

dw 0xaa55                       ; BIOS magic end of boot-sector number
