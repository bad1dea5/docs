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

## Function

```assembly
;extern "c" int main(char*, char*)
;{
00007FF744ED2180  mov         qword ptr [rsp+10h],rdx  
00007FF744ED2185  mov         qword ptr [rsp+8],rcx  
00007FF744ED218A  sub         rsp,68h  

;	return test(1,2,3,4,5,6,7,8,9,10,11);
00007FF744ED218E  mov         dword ptr [rsp+50h],0Bh  
00007FF744ED2196  mov         dword ptr [rsp+48h],0Ah  
00007FF744ED219E  mov         dword ptr [rsp+40h],9  
00007FF744ED21A6  mov         dword ptr [rsp+38h],8  
00007FF744ED21AE  mov         dword ptr [rsp+30h],7  
00007FF744ED21B6  mov         dword ptr [rsp+28h],6  
00007FF744ED21BE  mov         dword ptr [rsp+20h],5  
00007FF744ED21C6  mov         r9d,4  
00007FF744ED21CC  mov         r8d,3  
00007FF744ED21D2  mov         edx,2  
00007FF744ED21D7  mov         ecx,1  
00007FF744ED21DC  call        test (07FF744ED1087h)  
;}
00007FF744ED21E1  add         rsp,68h  
00007FF744ED21E5  ret

;
;
;

;INT test(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j, int k)
;{
00007FF744ED20E0  mov         dword ptr [rsp+20h],r9d  
00007FF744ED20E5  mov         dword ptr [rsp+18h],r8d  
00007FF744ED20EA  mov         dword ptr [rsp+10h],edx  
00007FF744ED20EE  mov         dword ptr [rsp+8],ecx  
00007FF744ED20F2  sub         rsp,78h  
;	qword x = 0xffffbad1dea5ffff;
00007FF744ED20F6  mov         rax,0FFFFBAD1DEA5FFFFh  
00007FF744ED2100  mov         qword ptr [x],rax  

;	return pop(a, b, c, d, e, f, g, h, i, j, k);
00007FF744ED2105  mov         eax,dword ptr [k]  
00007FF744ED210C  mov         dword ptr [rsp+50h],eax  
00007FF744ED2110  mov         eax,dword ptr [j]  
00007FF744ED2117  mov         dword ptr [rsp+48h],eax  
00007FF744ED211B  mov         eax,dword ptr [i]  
00007FF744ED2122  mov         dword ptr [rsp+40h],eax  
00007FF744ED2126  mov         eax,dword ptr [h]  
00007FF744ED212D  mov         dword ptr [rsp+38h],eax  
00007FF744ED2131  mov         eax,dword ptr [g]  
00007FF744ED2138  mov         dword ptr [rsp+30h],eax  
00007FF744ED213C  mov         eax,dword ptr [f]  
00007FF744ED2143  mov         dword ptr [rsp+28h],eax  
00007FF744ED2147  mov         eax,dword ptr [e]  
00007FF744ED214E  mov         dword ptr [rsp+20h],eax  
00007FF744ED2152  mov         r9d,dword ptr [d]  
00007FF744ED215A  mov         r8d,dword ptr [c]  
00007FF744ED2162  mov         edx,dword ptr [b]  
00007FF744ED2169  mov         ecx,dword ptr [a]  
00007FF744ED2170  call        pop (07FF744ED1082h)  
;}
00007FF744ED2175  add         rsp,78h  
00007FF744ED2179  ret

;
;
;

;long pop(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j, int k)
;{
00007FF744ED2090  mov         dword ptr [d],r9d  
00007FF744ED2095  mov         dword ptr [c],r8d

;long pop(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j, int k)
;{
00007FF744ED209A  mov         dword ptr [b],edx  
00007FF744ED209E  mov         dword ptr [a],ecx  
;	return (a + b + c + d + e + f + g + h + i + j + k);
00007FF744ED20A2  mov         eax,dword ptr [b]  
00007FF744ED20A6  mov         ecx,dword ptr [a]  
00007FF744ED20AA  add         ecx,eax  
00007FF744ED20AC  mov         eax,ecx  
00007FF744ED20AE  add         eax,dword ptr [c]  
00007FF744ED20B2  add         eax,dword ptr [d]  
00007FF744ED20B6  add         eax,dword ptr [e]  
00007FF744ED20BA  add         eax,dword ptr [f]  
00007FF744ED20BE  add         eax,dword ptr [g]  
00007FF744ED20C2  add         eax,dword ptr [h]  
00007FF744ED20C6  add         eax,dword ptr [i]  
00007FF744ED20CA  add         eax,dword ptr [j]  
00007FF744ED20CE  add         eax,dword ptr [k]  
;}
00007FF744ED20D2  ret
```
