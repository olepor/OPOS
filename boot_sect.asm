  ;;
  ;; A simple boot-sector program that loops forever
  ;;
[org 0x7c00]

mov ah, 0x0e                    ; int 10/ah -> Scrolling BIOS teletype routine

mov al, [the_secret]
int 0x10




jmp $                           ; jump to current address (ie forever)

the_secret:
  db 'X'

times 510 - ($ - $$) db 0       ; pad the boot-sector with zeros

dw 0xaa55                       ; BIOS magic end of boot-sector number
