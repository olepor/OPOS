  [bits 32]
  [extern main]                 ; declare that we will be referencing the external symbol main,
  ;;  so that the linker can resolve the physical address for us
  call main
  jmp $
