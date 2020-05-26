## AARCH64

> There are thirty-one, 64-bit, general-purpose (integer) registers visible to the A64 instruction set;
> these are labeled r0-r30. In a 64-bit context these registers are normally referred to using the names x0-x30;
> in a 32-bit context the registers are specified by using w0-w30.

Register | Special | Role
--- | --- | ---
`r0...r7` | | Parameter/result registers
`r8` | | Indirect result location register
`r9...r15` | | Temporary registers
`r16` | IP0 | The first intra-procedure-call scratch register (can be used by call veneers and PLT code); at other times may be used as a temporary register.
`r17` | IP1 | The second intra-procedure-call temporary register (can be used by call veneers and PLT code); at other times may be used as a temporary register.
`r18` | | The platform registers, if needed; otherwise a temorary register.
`r19...r28` | | Callee-saved registers
`r29` | FP | Frame pointer
`r30` | LR | Link register
`sp` | | Stack pointer

### Reference
[https://sourceware.org/binutils/docs/as/](https://sourceware.org/binutils/docs/as/)
