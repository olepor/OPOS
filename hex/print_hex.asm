;;
;; simple assembly function to print hex-values
;;

print_hex:
  ;; dx contains two bytes (16 bits),
  ;; but four characters need to be printed
  pusha                         ; store all registers on the stack
  mov cx, 0                     ; loop iterations
  mov si, HEX_OUT + 2           ; dont need the first two bytes
lp:
  mov bx, dx                    ; use bx as cache
  shl dx, 4                     ; ready the next byte
  and bx, 0xf000                ; get the first byte
  shr bx, 12                    ; shift to the least sig-bit

  jmp convert_to_ascii
cont:
  ; move the byte into the correct location
  mov [si], bx
  inc si                     ; move the pointer ahead one byte
  inc cx                        ; increment loop counter
  cmp cx, 4
  je finish
  jmp lp

finish:
  mov bx, HEX_OUT               ; print the string pointed to
  call print_string             ; by bx
  popa
  ret

convert_to_ascii:
  cmp bx, 9
  jle add_dec_offset
  jg add_char_offset

add_char_offset:
  add bx, 87                    ; make the ascii value
  jmp cont

add_dec_offset:
  add bx, 48
  jmp cont

; global variables
HEX_OUT:
  db '0x0000', 0
