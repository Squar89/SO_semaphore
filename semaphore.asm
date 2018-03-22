section .text
  global proberen
  global verhogen
  global proberen_time
  extern get_os_time

verhogen:
  lock add  DWORD [rdi], esi
  ret

revert:
  lock add  DWORD [rdi], esi

proberen:
  cmp   DWORD [rdi], esi
  jl    proberen

  xor   edx, edx
  sub   edx, esi
  lock xadd   DWORD [rdi], edx

  cmp   edx, esi
  jl    revert
  ret

proberen_time:
  sub   rsp, 0x8
  call  get_os_time
  mov   r10, rax

  jmp   proberen

  call  get_os_time
  add   rsp, 0x8

  sub   rax, r10
  ret