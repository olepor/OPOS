[bits 32]
; Constants
  VIDEO_MEMORY equ 0xb8000
  WHITE_ON_BLACK equ 0x0f

  ; prints a null-terminated string pointed to by EDX
print_string_pm:
  pusha                         ; always keep our environment clean
  mov edx, VIDEO_MEMORY         ; Set EDX to the start of our memory

print_string_pm_loop:
  mov al, [ebx]                 ; Store the char at &EBX in AL
  mov ah, WHITE_ON_BLACK        ; Store the attributes in ah

  cmp al, 0                     ; Check end of string
  je print_string_pm_done

  mov [edx], ax                 ; Store char and attribute at current character cell

  inc ebx                       ; Next char
  add edx, 2                    ; Nech char in vid mem

  jmp print_string_pm_loop      ; continue

print_string_pm_done:
  popa                          ; recreate the environment pre function
  ret

