# Calling Convention

The first four arguments are placed onto the registers.

- `rcx` `rdx` `r8` `r9` for integer, struct or pointer arguments.
- `xmm0` `xmm1` xmm2` xmm3` for floating point arguments.

Additional arguments are pushed onto the stack from right to left.

Integer return values are returned in `rax` if 64 bits or less.
Floating point return values are returned in `xmm0`
Parameters less than 64 bits long are not zero extended; the high
bits are not zeroed.

## Shadow space

It is the callers responsibility to allocate 32 bytes of 'shadow space' on the stack before calling the function, and to pop afterwards. The shadow space is used to spill `rcx`, `rdx`, `r8`, and `r9`, but must be made available to all functions, even those with fewer than four parameters.

type | registers
--- | ---
volatile (caller-saved) | `rax`, `rcx`, `rdx`, `r8`, `r9`, `r10`, `r11`
nonvolatile (callee-saved) | `rbx`, `rbp`, `rdi`, `rsi`, `rsp`, `r12`, `r13`, `r14`, `r15`
preserve  | `xmm6`, `xmm7`
