## _start

The default entrypoint, can be changed be the linker with `--entry`.

> `-e entry`
>
> `--entry=entry`
>
> Specify that the program entry point is entry. The argument is interpreted by the linker; 
> the GNU linker accepts either a symbol name or an address.

## Calling Convention

arg1 | arg2 | arg3 | arg4 | arg5 | arg6 | arg7+
--- | --- | --- | --- | --- | --- | ---
`rdi` | `rsi` | `rdx` | `rcx` | `r8` | `r9` | stack

## Example

```nasm
EXTERN main
EXTERN exit

GLOBAL _start

SECTION .text
  _start:
    sub rsp, 20h

    call main

    mov edi, eax
    call exit

    add rsp, 20h
    ret
```

## GDB
```
rdi = 0x2
rsi = 0x7ffff7ffe700        0x00007FFFF7FFE700  00 00 00 00 00 00 00 00  ........
rdx = 0x7ffff7de59a0        0x00007FFFF7DE59A0  55 48 89 e5 41 57 41 56  UH.åAWAV
rcx = 0x7ffff7dd3de0        0x00007FFFF7DD3DE0  19 00 00 00 00 00 00 00  ........
r8  = 0x7ffff7ffc800        0x00007FFFF7FFC800  06 00 00 00 16 00 00 00  ........
r9  = 0x7ffff7ffc804        0x00007FFFF7FFC804  16 00 00 00 00 00 00 00  ........
```

## Stack
```
rsp = 0x7fffffffea20

0x00007FFFFFFFEA20  02 00 00 00 00 00 00 00  ........
0x00007FFFFFFFEA28  7e ec ff ff ff 7f 00 00  ~ìÿÿÿ...
0x00007FFFFFFFEA30  ba ec ff ff ff 7f 00 00  ºìÿÿÿ...
0x00007FFFFFFFEA38  00 00 00 00 00 00 00 00  ........

[rsp + 8]   = full path to application
[rsp + 16]  = command line arguments
```

### Reference
- [Linker Options](https://gcc.gnu.org/onlinedocs/gcc/Link-Options.html)
