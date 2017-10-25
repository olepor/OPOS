;;
;; load DH sectors to ES:BX from drive DL
;;
disk_load:
  push dx                       ; Remember dx, so that we can recall
                                ; how many sectors were requested read.
  mov ah, 0x02                  ; BIOS read sector function
  mov al, dh                    ; read DH sectors
  mov ch, 0x00                  ; Select cylinder 0
  mov dh, 0x00                  ; Select head 0
  mov cl, 0x02                  ; Start reading from the second sector

  int 0x13                      ; BIOS interrupt

  jc disc_error                 ; Jump if error (i.e. carry flag set)

  pop dx                        ; restore the dx register
  cmp dh, al                    ; If Al != DH (sectors read) vs (expecter)
  jne disc_error                ; display error message

  ret

disc_error:
  mov bx, DISC_ERROR_MESSAGE
  call print_string
  jmp $

; Variables
  DISC_ERROR_MESSAGE db "Disc read error!", 0
