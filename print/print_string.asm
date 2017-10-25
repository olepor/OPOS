;;
;; simple function to print zero-padded strings pointed
;;  to by the bx register
;;

print_string:
  ; the address of the zero-terminated string is stored in the bx-register
  pusha                         ; push all registers onto the stack,
  mov ah, 0x0e                  ; BIOS tele-type output
p_loop:
  mov al, [bx]                  ; move the contents of &b into al
  cmp al, 0
  je exit_block
  add bx, 1                     ; increment the b pointer
  int 0x10                      ; interrupt
  jmp p_loop                    ; continue printing

exit_block:                     ; clean up the function
  popa                          ; pop all stack elements
  ret                           ; return and reset instruction-pointer
