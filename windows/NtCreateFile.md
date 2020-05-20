### NtCreateFile

  > ```c
  > __kernel_entry NTSTATUS NtCreateFile(
  > OUT PHANDLE           FileHandle,
  > IN ACCESS_MASK        DesiredAccess,
  > IN POBJECT_ATTRIBUTES ObjectAttributes,
  > OUT PIO_STATUS_BLOCK  IoStatusBlock,
  > IN PLARGE_INTEGER     AllocationSize,
  > IN ULONG              FileAttributes,
  > IN ULONG              ShareAccess,
  > IN ULONG              CreateDisposition,
  > IN ULONG              CreateOptions,
  > IN PVOID              EaBuffer,
  > IN ULONG              EaLength
  > );
  > ```

```assembly
public NtCreateFile
NtCreateFile proc near

var_68= dword ptr -68h
var_60= dword ptr -60h
var_58= dword ptr -58h
var_50= dword ptr -50h
var_48= dword ptr -48h
Src= qword ptr -40h
NumberOfBytes= qword ptr -38h
var_30= dword ptr -30h
var_28= dword ptr -28h
var_20= qword ptr -20h
var_18= dword ptr -18h
var_10= dword ptr -10h
arg_20= dword ptr  28h
arg_28= dword ptr  30h
arg_30= dword ptr  38h
arg_38= dword ptr  40h
arg_40= dword ptr  48h
arg_48= qword ptr  50h
arg_50= qword ptr  58h

sub     rsp, 88h
xor     eax, eax
mov     qword ptr [rsp+88h+var_10], rax ; int
mov     [rsp+88h+var_18], 20h ; int
mov     dword ptr [rsp+88h+var_20], eax ; __int64
mov     qword ptr [rsp+88h+var_28], rax ; int
mov     [rsp+88h+var_30], eax ; int
mov     eax, dword ptr [rsp+88h+arg_50]
mov     dword ptr [rsp+88h+NumberOfBytes], eax ; NumberOfBytes
mov     rax, [rsp+88h+arg_48]
mov     [rsp+88h+Src], rax ; Src
mov     eax, [rsp+88h+arg_40]
mov     [rsp+88h+var_48], eax ; int
mov     eax, [rsp+88h+arg_38]
mov     [rsp+88h+var_50], eax ; int
mov     eax, [rsp+88h+arg_30]
mov     [rsp+88h+var_58], eax ; int
mov     eax, [rsp+88h+arg_28]
mov     [rsp+88h+var_60], eax ; int
mov     rax, qword ptr [rsp+88h+arg_20]
mov     qword ptr [rsp+88h+var_68], rax ; int
call    sub_1406649A0
add     rsp, 88h
retn

NtCreateFile endp
```
