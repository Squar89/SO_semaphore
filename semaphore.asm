section .text
  global proberen
  global verhogen
  global proberen_time
  extern get_os_time

verhogen:
  lock add   DWORD [rdi], esi
  ret

revert:
  lock add   DWORD [rdi], esi

proberen:
  cmp   DWORD [rdi], esi
  jl    proberen

  ;clear edx register and store neg esi in it
  xor   edx, edx
  sub   edx, esi
  lock xadd   DWORD [rdi], edx
  ;now edx holds old semaphore value (before xadd)

  ;compare old semaphore value with value subtracted (and revert subtraction if needed)
  cmp   edx, esi
  jl    revert
  ret

proberen_time:
  ;push 8 bytes so stack is 16 bytes aligned when we call another function
  sub   rsp, 0x8
  push  rdi
  push  rsi

  call  get_os_time

  pop   rsi
  pop   rdi
  mov   r10, rax   ;store entry time in r10

  call  proberen

  call  get_os_time
  add   rsp, 0x8   ;pop 8 bytes added earlier

  sub   rax, r10   ;leave time - entry time
  ret