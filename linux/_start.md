## _start

The default entrypoint. Can be changed by the linker with `--entry`.

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
rdi = 0x7ffff7ffe170  ; 0x00007FFFF7FFE170  00 40 55 55 55 55 00 00  .@UUUU..
rsi = 0x7ffff7ffe700  ; 0x00007FFFF7FFE700  00 00 00 00 00 00 00 00  ........
rdx = 0x7ffff7de59a0  ; 0x00007FFFF7DE59A0  55 48 89 e5 41 57 41 56  UH.åAWAV
rcx = 0x7fffffffea58  ; 0x00007FFFFFFFEA58  c0 ec ff ff ff 7f 00 00  Àìÿÿÿ...
r8  = 0x0
r9  = 0x0

rsp = 0x7fffffffea40 
```

`rdi` Pointer to an address, where the application has been loaded

`rsi` ?

`rdx` ?

`rcx` An array of pointers, of which, the last one being `NULL`

```
0x00007FFFFFFFEA58  c0 ec ff ff ff 7f 00 00  Àìÿÿÿ...
0x00007FFFFFFFEA60  cb ec ff ff ff 7f 00 00  Ëìÿÿÿ...
0x00007FFFFFFFEA68  fd ec ff ff ff 7f 00 00  ýìÿÿÿ...
0x00007FFFFFFFEA70  1f ed ff ff ff 7f 00 00  .íÿÿÿ...
0x00007FFFFFFFEA78  2e ed ff ff ff 7f 00 00  .íÿÿÿ...
0x00007FFFFFFFEA80  3f ed ff ff ff 7f 00 00  ?íÿÿÿ...
0x00007FFFFFFFEA88  53 ed ff ff ff 7f 00 00  Síÿÿÿ...
0x00007FFFFFFFEA90  61 ed ff ff ff 7f 00 00  aíÿÿÿ...
0x00007FFFFFFFEA98  7d ed ff ff ff 7f 00 00  }íÿÿÿ...
0x00007FFFFFFFEAA0  b4 ed ff ff ff 7f 00 00  ´íÿÿÿ...
0x00007FFFFFFFEAA8  bd ed ff ff ff 7f 00 00  .íÿÿÿ...
0x00007FFFFFFFEAB0  d1 ed ff ff ff 7f 00 00  Ñíÿÿÿ...
0x00007FFFFFFFEAB8  f2 ed ff ff ff 7f 00 00  òíÿÿÿ...
0x00007FFFFFFFEAC0  6d ee ff ff ff 7f 00 00  mîÿÿÿ...
0x00007FFFFFFFEAC8  80 ee ff ff ff 7f 00 00  €îÿÿÿ...
0x00007FFFFFFFEAD0  8c ee ff ff ff 7f 00 00  Œîÿÿÿ...
0x00007FFFFFFFEAD8  a4 ee ff ff ff 7f 00 00  ¤îÿÿÿ...
0x00007FFFFFFFEAE0  b4 ee ff ff ff 7f 00 00  ´îÿÿÿ...
0x00007FFFFFFFEAE8  be ee ff ff ff 7f 00 00  .îÿÿÿ...
0x00007FFFFFFFEAF0  c6 ee ff ff ff 7f 00 00  Æîÿÿÿ...
0x00007FFFFFFFEAF8  d8 ee ff ff ff 7f 00 00  Øîÿÿÿ...
0x00007FFFFFFFEB00  e9 ee ff ff ff 7f 00 00  éîÿÿÿ...
0x00007FFFFFFFEB08  1f ef ff ff ff 7f 00 00  .ïÿÿÿ...
0x00007FFFFFFFEB10  3e ef ff ff ff 7f 00 00  >ïÿÿÿ...
0x00007FFFFFFFEB18  9c ef ff ff ff 7f 00 00  œïÿÿÿ...
0x00007FFFFFFFEB20  00 00 00 00 00 00 00 00  ........
```

The first pointer in the list `0x00007fffffffecc0` is the start of the of environment string.
Each pointer points to a variable in this string.

## Stack

```
0x00007FFFFFFFEA40  00 00 00 00 00 00 00 00  ........
0x00007FFFFFFFEA48  84 ec ff ff ff 7f 00 00  .ìÿÿÿ...
0x00007FFFFFFFEA50  00 00 00 00 00 00 00 00  ........
0x00007FFFFFFFEA58  c0 ec ff ff ff 7f 00 00  Àìÿÿÿ...
```

`rsp + 8h` = Full path to application

`rsp + 10h` Command line arguments

`rsp + 18h` = `rcx` = Environment arguments

### Reference
- [Linker Options](https://gcc.gnu.org/onlinedocs/gcc/Link-Options.html)
