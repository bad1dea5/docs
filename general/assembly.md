# Assembly

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
