## NASM

## GOT

```assembly
EXTERN _GLOBAL_OFFSET_TABLE_

push    rbp 
mov     rbp, rsp 
push    rbx 
call    .get_GOT 

.get_GOT: 
  pop     rbx 
  add     rbx,_GLOBAL_OFFSET_TABLE_+$$-.get_GOT wrt ..gotpc 

; the function body comes here 

mov     rbx,[rbp-8] 
mov     rsp,rbp 
pop     rbp 
ret
```
