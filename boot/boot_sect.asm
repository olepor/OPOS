  ;;
  ;; a boot-sector that boots a c-kernel in 32-bit protected mode
  ;;
[org 0x7c00]                    ; tell the assembler where this code will be loaded

  KERNEL_OFFSET equ 0x1000

  mov [BOOT_DRIVE], dl          ; BIOS stores our boot-drive in dl, so remember this for later

  mov bp, 0x9000                ; setup the stack
  mov sp, bp

  mov bx, MSG_REAL_MODE
  call print_string             ; booting from 16-bit real-mode

  call load_kernel              ; self-explanatory

  call switch_to_pm             ; make the switch to 32-bit mode

  jmp $                         ; hang

%include "boot/print/print_string.asm"
%include "boot/print/print_string_pm.asm"
%include "boot/hex/print_hex.asm"
%include "boot/disk_load.asm"
%include "boot/gdt.asm"
%include "boot/switch_to_pm.asm"

[bits 16]

load_kernel:

  mov bx, MSG_LOAD_KERNEL
  call print_string

  mov bx, KERNEL_OFFSET         ; setup the parameters for our disc-load routine
  mov dh, 15                    ; load the first 15 sectors (excluding the boot-sector)
  mov dl, [BOOT_DRIVE]          ; from the boot-disc (i.e. our kernel)

  call disk_load

  mov dx, KERNEL_OFFSET
  call switch_to_pm

  ret                           ; never forget

[bits 32]

; Arrive here after switching to protected mode
BEGIN_PM:

  mov ebx, MSG_PROT_MODE
  call print_string_pm          ; use our 32-bit print routine

  call KERNEL_OFFSET            ; now jump to the address of our loaded kernel-code

  jmp $                         ; hang

  ; Global variables
BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit real-mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit protected mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0
MSG_TEST db "Test", 0


  ; Boot-sector padding
times 510 - ($ - $$) db 0       ; pad the boot-sector with zeros

dw 0xaa55                       ; BIOS magic end of boot-sector number
