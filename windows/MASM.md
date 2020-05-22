## MASM

### struct
```assembly
IO_STATUS_BLOCK struct
	Pointer     QWORD ?
	Information QWORD ?
IO_STATUS_BLOCK ENDS

LOCAL io: IO_STATUS_BLOCK

mov io.Pointer, 0
mov io.Information, 0
```
