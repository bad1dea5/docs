# Calling Convention

There are sixteen general-purpose registers. The lower 32 bits, 16 bits, and 8 bits of each register are addressable. Also are eight 80-bit floating point and 64-bit MMX registers, of which are overlaid, sixteen 128bit XMM registers and one 64-bit `RFLAGS` register. The higher 32 bits of `RFLAGS` are reserved and unused.

| # | 1 | 2 | 3 | 4 | 5 | 6 | 7+ |
 -- | -- | -- | -- | -- | -- | -- | --
Userspace | `rdi` | `rsi` | `rdx` | `rcx` | `r8` | `r9` | stack
Kernel    | `rdi` | `rsi` | `rdx` | `r10` | `r8` | `r9` | stack

The stack pointer must be aligned to a 16-byte boundary before making a call. The previous call instruction pushes 8 bytes, so when the function gains control, the stack is unaligned. To align the stack `push` or `sub` eight bytes.

```assembly
.globl _start
.text
	_start:
		push %rbp
		sub 30h, %rsp
		call main
		add 30h, %rsp
		pop %rbp
```
