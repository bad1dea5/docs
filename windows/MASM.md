## MASM

### struct
```assembly
IO_STATUS_BLOCK struct QWORD
	UNION u
		Status DWORD ?
		Pointer QWORD ?
	ENDS
	Information QWORD ?
IO_STATUS_BLOCK ends

LOCAL io: IO_STATUS_BLOCK

mov io.Pointer, 0
mov io.Information, 0
```
