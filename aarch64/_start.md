## _start

```assembly
.extern main

.globl _start

.text

	_start:
		
		bl main

		mov x0, 0
		mov x8, 93
		svc #0
```

```
x0 = 0xfffff7fdb590   0x0000FFFFF7FDB590  fd 7b b8 a9 00 01 00 f0  ý{¸©...ð
x1 = 0xfffff7fff788   0x0000FFFFF7FFF788  00 00 00 00 00 00 00 00  ........
x2 = 0xfffffffffaa8   0x0000FFFFF7FFFAA8  40 fd ff f7 ff ff 00 00  @ýÿ÷ÿÿ..
x3 = 0x0
x4 = 0x14
x5 = 0x3f
x6 = 0x0
x7 = 0xfffff7ffc1e0   0x0000FFFFF7FFC1E0  00 5f 5f 6b 65 72 6e 65  .__kerne

sp = 0xfffffffffaa0
```

```
0x0000FFFFF7FFC000  7f 45 4c 46 02 01 01 00  .ELF...
0x0000FFFFFFFFFAA0  01 00 00 00 00 00 00 00  ........
```
