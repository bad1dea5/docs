# Assembly

### Calling convention
| | arg1 | arg2 | arg3 | arg4 | arg5 | arg6 | arg7+ |
| ------------ | ------------ | ------------ | ------------ | ------------ | ------------ | ------------ | ------------ |
| Windows   | rcx | rdx | r8 | r8 | stack |   |   |
| | | | | | |   |   |
| Linux user | rdi | rsi | rdx | rcx | r8 | r9 | stack |
| Linux kernel | rdi | rsi | rdx | r10 | r8 | r9 | stack |

### lea
```assembly
lea rax, buffer   ; pointer
mov rax, buffer   ; content
```

### Jump

```assembly
00007FF7AB6B20A8 EB 63                jmp         Func+6Bh (07FF7AB6B210Dh)
00007FF7EF4920A8 E9 90 00 00 00       jmp         Func+9Bh (07FF7EF49213Dh)
```

```EB ; jmp rel8``` **Short jump**	- [2 bytes] A jump where the jump range is limited to –128 to +127 from the current EIP value.

```E9	; jmp rel32``` **Near jump**	- [5 bytes] A jump to an instruction within the current code segment (the segment currently pointed to by the CS register).

```jmp near ptr label``` for near jump.

### shr

```assembly
0x000055555555563e 48 b9 ef cd ab 90 78 56 34 12    movabs  $0x1234567890abcdef,%rcx    ; mov rcx, 0x1234567890abcdef
0x0000555555555648 48 c1 e9 20                      shr     $0x20,%rcx                  ; shr rcx, 32

rcx = 0x1234567890abcde
rcx = 0x12345678
```
