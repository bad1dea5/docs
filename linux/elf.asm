;
;	ELF x86-64
;

bits 64

;
;
;

%define Round(x,y)				(((x+(y-1))/y)*y)
%define BSS_SIZE 				8

%define ELF64_R_SYM(x)			((x)>>32)
%define ELF64_R_TYPE(x)			((x)&0xffffffff)
%define ELF64_R_SYM(x,y)		(((x)<<32)+((y)&0xffffffff))

%define ELF64_ST_BIND(x)		((x)>>4)
%define ELF64_ST_TYPE(x)		((x)&0xf)
%define ELF64_ST_INFO(x,y)		(((x)<<4)+((y)&0xf))

%define ELF64_ST_VISIBILITY(x)	((x)&0x3)

%define DT_NULL					0
%define DT_NEEDED				1
%define DT_PLTRELSZ				2
%define DT_PLTGOT				3
%define DT_HASH					4
%define DT_STRTAB				5
%define DT_SYMTAB				6
%define DT_RELA					7
%define DT_RELASZ				8
%define DT_RELAENT				9
%define DT_STRSZ				10
%define DT_SYMENT				11
%define DT_INIT					12
%define DT_FINI					13
%define DT_SONAME				14
%define DT_RPATH 				15
%define DT_SYMBOLIC				16
%define DT_REL					17
%define DT_RELSZ				18
%define DT_RELENT				19
%define DT_PLTREL				20
%define DT_DEBUG				21
%define DT_TEXTREL				22
%define DT_JMPREL				23
%define DT_INIT_ARRAY			25
%define DT_FINI_ARRAY			26
%define DT_INIT_ARRAYSZ			27
%define DT_FINI_ARRAYSZ			28
%define DT_FLAGS				30
%define DT_ENCODING				32
%define DT_FLAG_1				0x6ffffffb
%define DT_RELACOUNT			0x6ffffff9

%define DT_BIND_NOW				8
%define DT_FLAG_PIE				0x8000001

%define PF_X					1
%define PF_W					2
%define PF_R					4

%define PT_NULL					0
%define PT_LOAD					1
%define PT_DYNAMIC				2
%define PT_INTERP				3
%define PT_NOTE					4
%define PT_SHLIB				5
%define PT_PHDR					6
%define PT_TLS					7
%define PT_GNU_EH_FRAME			0x6474e550
%define PT_GNU_STACK			0x6474e551
%define PT_GNU_RELRO			0x6474e552

%define SHT_NULL				0
%define SHT_PROGBITS			1
%define SHT_SYMTAB				2
%define SHT_STRTAB				3
%define SHT_RELA				4
%define SHT_HASH				5
%define SHT_DYNAMIC				6
%define SHT_NOTE				7
%define SHT_NOBITS				8
%define SHT_REL					9
%define SHT_SHLIB				10
%define SHT_DYNSYM				11
%define SHT_NUM					12
%define SHT_INIT_ARRAY			14
%define SHT_FINI_ARRAY			15

%define STB_LOCAL				0
%define STB_GLOBAL				1
%define STB_WEAK				2

%define STN_UNDEF				0

%define STT_NOTYPE				0
%define STT_OBJECT				1
%define STT_FUNC				2
%define STT_SECTION				3
%define STT_FILE				4

;
;	ELF HEADER
;
EHDR:
	dd 0x464c457f								; e_ident[EL_MAG]
	db 2										; e_ident[EL_CLASS]
	db 1										; e_ident[EL_DATA]
	db 1										; e_ident[EL_VERSION]
	db 0										; e_ident[EL_OSABI]
	db 0										; e_ident[EL_ABIVERSION]
	times 7 db 0								; e_ident[EL_PAD]	
	dw 3										; e_type
	dw 0x3e										; e_machine
	dd 1										; e_version
	dq ENTRY									; e_entry
	dq PHDR										; e_phoff
	dq SHDR 									; e_shoff
	dd 0										; e_flags
	dw EHDR_SIZE								; e_ehsize
	dw PHDR_ENTRY_SIZE							; e_phentsize
	dw 7										; e_phnum
	dw SHDR_ENTRY_SIZE							; e_shentsize
	dw 20										; e_shnum
	dw 19										; e_shstrndx
	
EHDR_SIZE equ $ - EHDR

;
;	PROGRAM HEADER
;	
PHDR:
	dd PT_PHDR									; p_type
	dd PF_R										; p_flags
	dq PHDR										; p_offset
	dq PHDR										; p_vaddr
	dq PHDR										; p_paddr
	dq PHDR_SIZE								; p_filesz
	dq PHDR_SIZE								; p_memsz
	dq 8										; p_align
	
	PHDR_ENTRY_SIZE equ $ - PHDR

	;
	;	INTERP
	;
	dd PT_INTERP								; p_type
	dd PF_R										; p_flags
	dq INTERP									; p_offset
	dq INTERP									; p_vaddr
	dq INTERP									; p_paddr
	dq INTERP_SIZE								; p_filesz
	dq INTERP_SIZE								; p_memsz
	dq 1										; p_align

	;
	;	LOAD
	;
	dd PT_LOAD									; p_type
	dd PF_R | PF_X								; p_flags
	dq 0										; p_offset
	dq 0										; p_vaddr
	dq 0										; p_paddr
	dq LOAD_SECTION_SIZE						; p_filesz
	dq LOAD_SECTION_SIZE						; p_memsz
	dq 0x200000									; p_align
	
	;
	;	LOAD
	;
	dd PT_LOAD									; p_type
	dd PF_R |PF_W								; p_flags
	dq DYNAMIC_SECTION							; p_offset
	dq DYNAMIC_SECTION + 0x200000				; p_vaddr
	dq DYNAMIC_SECTION + 0x200000				; p_paddr
	dq DYNAMIC_SECTION_SIZE						; p_filesz
	dq Round(DYNAMIC_SECTION_SIZE, 8)			; p_memsz
	dq 0x200000									; p_align
	
	;
	;	DYNAMIC
	;
	dd PT_DYNAMIC								; p_type
	dd PF_R |PF_W								; p_flags
	dq DYNAMIC									; p_offset
	dq DYNAMIC + 0x200000						; p_vaddr
	dq DYNAMIC + 0x200000						; p_paddr
	dq DYNAMIC_SIZE								; p_filesz
	dq DYNAMIC_SIZE								; p_memsz
	dq 8										; p_align
	
	;
	;	GNU_STACK
	;
	dd PT_GNU_STACK								; p_type
	dd PF_R |PF_W								; p_flags
	dq 0										; p_offset
	dq 0										; p_vaddr
	dq 0										; p_paddr
	dq 0										; p_filesz
	dq 0										; p_memsz
	dq 16										; p_align
	
	;
	;	GNU_RELRO
	;
	dd PT_GNU_RELRO								; p_type
	dd PF_R										; p_flags
	dq DYNAMIC_SECTION							; p_offset
	dq DYNAMIC_SECTION + 0x200000				; p_vaddr
	dq DYNAMIC_SECTION + 0x200000				; p_paddr
	dq DATA_END - DYNAMIC_SECTION				; p_filesz
	dq DATA_END - DYNAMIC_SECTION + BSS_SIZE	; p_memsz
	dq 1										; p_align
	
	PHDR_SIZE equ $ - PHDR

	;
	;	INTERP
	;
	INTERP:
		db '/lib64/ld-linux-x86-64.so.2', 0
	INTERP_SIZE equ $ - INTERP
	
	;
	;	HASH TABLE
	;
	align 8
	
	HASH:
		dd 1	; nbuckets
		dd 4	; nsymbols
		dd 1	; bucket
		dd 0	;
		dd 0	;
	HASH_SIZE equ $ - HASH

	;
	;	DYNSTR
	;
	DYNSTR:
		db 0,
		db 'libdl.so.2', 0	; 1
		db 'dlopen', 0		; 12
		db 'dlclose', 0		; 19
		db 'dlsym', 0		; 27
	DYNSTR_SIZE equ $ - DYNSTR
	
	;
	;	DYNSYM
	;
	align 8
	
	DYNSYM:
		dd 0									; st_name
		db 0									; st_info
		db 0									; st_other
		dw 0									; st_shndx
		dq 0									; st_value
		dq 0									; st_size
			
		DYNSYM_ENTRY_SIZE equ $ - DYNSYM
		
		dd 12									; st_name
		db 18									; st_info
		db 0									; st_other
		dw 0									; st_shndx
		dq 0									; st_value
		dq 0									; st_size
		
		dd 19									; st_name
		db 18									; st_info
		db 0									; st_other
		dw 0									; st_shndx
		dq 0									; st_value
		dq 0									; st_size
		
		dd 27									; st_name
		db 18									; st_info
		db 0									; st_other
		dw 0									; st_shndx
		dq 0									; st_value
		dq 0									; st_size
		
	DYNSYM_SIZE equ $ - DYNSYM
	
	;
	;	RELA.DYN
	;
	align 8
	
	RELA.DYN:
		dq INIT_ARRAY + 0x200000				; r_offset
		dq 8									; r_info
		dq FRAME_DUMMY							; r_addend
		
		RELA.DYN_ENTRY_SIZE equ $ - RELA.DYN
		
		dq FINI_ARRAY + 0x200000				; r_offset
		dq 8									; r_info
		dq FRAME_DUMMY							; r_addend
		
	RELA.DYN_SIZE equ $ - RELA.DYN
	
	;
	;	RELA.PLT
	;
	align 8
	
	RELA.PLT:
		dq dlopen + 0x200000					; r_offset
		dq 0x000100000007						; r_info
		dq 0									; r_addend
		
		RELA.PLT_ENTRY_SIZE equ $ - RELA.PLT
		
		dq dlclose + 0x200000					; r_offset
		dq 0x000200000007						; r_info
		dq 0									; r_addend
		
		dq dlsym + 0x200000						; r_offset
		dq 0x000300000007						; r_info
		dq 0									; r_addend
		
	RELA.PLT_SIZE equ $ - RELA.PLT
	
	;
	;	PLT
	;
	align 16
	
	PLT:
		push qword[rel GOT + 8 + 0x200000]
		jmp qword[rel GOT + 16 + 0x200000]
		nop dword [eax + 0x0]
		
		align 16
		
		_dlopen:
			jmp qword[rel dlopen + 0x200000]
			push strict dword 0
			jmp qword PLT
			
		_dlclose:
			jmp qword[rel dlclose + 0x200000]
			push strict dword 1
			jmp qword PLT
			
		_dlsym:
			jmp qword[rel dlsym + 0x200000]
			push strict dword 2
			jmp qword PLT
		
	PLT_SIZE equ $ - PLT
	
	;
	;	PLT.GOT
	;
	align 8
	
	PLT.GOT:
		dq 0
	PLT.GOT_SIZE equ $ - PLT.GOT

	;
	;	TEXT SECTION
	;
	align 16

	TEXT_SECTION:
		;
		;	ENTRY
		;
		ENTRY:	
			push		rbp
			mov			rbp, rsp
			
			sub			rsp, 48
			
			push		0x0a484157
			mov			rdx, 4
			lea			rsi, [rsp]
			mov			rax, 1
			mov			rdi, 1
			syscall
			
			;;
			lea			rdi, [rel filename]
			mov			esi, 1
			call		_dlopen
			;;
			
			mov			rdi, 0
			mov			rax, 60
			syscall
			
			pop			r10
			add			rsp, 48
			pop			rbp
			retn
		ENTRY_SIZE equ $ - ENTRY
		
		FRAME_DUMMY:
			push rbp
			mov rbp, rsp
			pop rbp		
		
	TEXT_SECTION_SIZE equ $ - TEXT_SECTION
	
	;
	;	RODATA
	;
	align 4
	
	RODATA:
		filename: db './librd.so', 0
	RODATA_SIZE equ $ - RODATA

LOAD_SECTION_SIZE equ $ - EHDR

;
;	DYNAMIC SECTION
;
align 8

DYNAMIC_SECTION:

	;
	;	INIT_ARRAY
	;
	align 8
	
	INIT_ARRAY:
		dq 0
	INIT_ARRAY_SIZE equ $ - INIT_ARRAY
	
	;
	;	FINI_ARRAY
	;
	align 8
	
	FINI_ARRAY:
		dq 0
	FINI_ARRAY_SIZE equ $ - FINI_ARRAY
	
	;
	;	DYNAMIC
	;
	DYNAMIC:
		dq DT_NEEDED,		1
		dq DT_PLTRELSZ,		RELA.PLT_SIZE
		dq DT_PLTGOT,		GOT + 0x200000
		dq DT_HASH,			HASH
		dq DT_STRTAB,		DYNSTR
		dq DT_SYMTAB,		DYNSYM
		dq DT_RELA,			RELA.DYN
		dq DT_RELASZ,		RELA.DYN_SIZE
		dq DT_RELAENT,		RELA.DYN_ENTRY_SIZE
		dq DT_STRSZ,		DYNSTR_SIZE
		dq DT_SYMENT,		DYNSYM_SIZE
		dq DT_PLTREL,		7
		dq DT_JMPREL,		RELA.PLT
		dq DT_INIT_ARRAY,	INIT_ARRAY + 0x200000
		dq DT_FINI_ARRAY,	FINI_ARRAY + 0x200000
		dq DT_INIT_ARRAYSZ,	INIT_ARRAY_SIZE
		dq DT_FINI_ARRAYSZ,	FINI_ARRAY_SIZE
		dq DT_FLAGS,		DT_BIND_NOW
		dq DT_FLAG_1,		DT_FLAG_PIE
		dq DT_RELACOUNT,	1
		dq 0, 0
	DYNAMIC_SIZE equ $ - DYNAMIC
	
	;
	;	GOT
	;
	align 8
	
	GOT:
		GLOBAL_OFFSET_TABLE: dq DYNAMIC + 0x200000
		dq 0
		dq 0
		dlopen: dq EXTERN_DATA + 0x200000
		dlclose: dq EXTERN_DATA + 0x200000 + 8
		dlsym: dq EXTERN_DATA + 0x200000 + 32
	GOT_SIZE equ $ - GOT
	
	;
	;	DATA
	;
	align 8
	
	DATA:
		dq 0
	DATA_SIZE equ $ - DATA
	DATA_END equ $
	
	;
	;	BSS
	;
	align 8
	BSS equ $
	
	EXTERN_DATA equ $ - $$
	
DYNAMIC_SECTION_SIZE equ $ - DYNAMIC_SECTION

;
;	SECTION HEADER
;
SHDR:
	dd 0										; sh_name
	dd 0										; sh_type
	dq 0										; sh_flags
	dq 0										; sh_addr
	dq 0										; sh_offset
	dq 0										; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 0										; sh_addralign
	dq 0										; sh_entsize
	
SHDR_ENTRY_SIZE equ $ - SHDR

	;
	;	INTERP
	;
	dd 17										; sh_name
	dd 1										; sh_type
	dq 2										; sh_flags
	dq INTERP									; sh_addr
	dq INTERP									; sh_offset
	dq INTERP_SIZE								; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 1										; sh_addralign
	dq 0										; sh_entsize
	
	;
	;	HASH
	;
	dd 86										; sh_name
	dd SHT_HASH									; sh_type
	dq 2										; sh_flags
	dq HASH										; sh_addr
	dq HASH										; sh_offset
	dq HASH_SIZE								; sh_size
	dd 4										; sh_link
	dd 0										; sh_info
	dq 8										; sh_addralign
	dq 0										; sh_entsize
	
	;
	;	DYNSTR
	;
	dd 34										; sh_name
	dd 3										; sh_type
	dq 2										; sh_flags
	dq DYNSTR									; sh_addr
	dq DYNSTR									; sh_offset
	dq DYNSTR_SIZE								; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 1										; sh_addralign
	dq 0										; sh_entsize
	
	;
	;	DYNSYM
	;
	dd 42										; sh_name
	dd 11										; sh_type
	dq 2										; sh_flags
	dq DYNSYM									; sh_addr
	dq DYNSYM									; sh_offset
	dq DYNSYM_SIZE								; sh_size
	dd 3										; sh_link
	dd 1										; sh_info
	dq 8										; sh_addralign
	dq DYNSYM_ENTRY_SIZE						; sh_entsize
	
	;
	;	RELA.DYN
	;
	dd 76										; sh_name
	dd 4										; sh_type
	dq 2										; sh_flags
	dq RELA.DYN									; sh_addr
	dq RELA.DYN									; sh_offset
	dq RELA.DYN_SIZE							; sh_size
	dd 4										; sh_link
	dd 0										; sh_info
	dq 8										; sh_addralign
	dq RELA.DYN_ENTRY_SIZE						; sh_entsize
	
	;
	;	RELA.PLT
	;
	dd 66										; sh_name
	dd 4										; sh_type
	dq 2										; sh_flags
	dq RELA.PLT									; sh_addr
	dq RELA.PLT									; sh_offset
	dq RELA.PLT_SIZE							; sh_size
	dd 4										; sh_link
	dd 14										; sh_info
	dq 8										; sh_addralign
	dq RELA.PLT_ENTRY_SIZE						; sh_entsize
	
	;
	;	PLT
	;
	dd 101										; sh_name
	dd 1										; sh_type
	dq 6										; sh_flags
	dq PLT										; sh_addr
	dq PLT										; sh_offset
	dq PLT_SIZE									; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 16										; sh_addralign
	dq 16										; sh_entsize
	
	;
	;	PLT.GOT
	;
	dd 106										; sh_name
	dd 1										; sh_type
	dq 6										; sh_flags
	dq PLT.GOT									; sh_addr
	dq PLT.GOT									; sh_offset
	dq PLT.GOT_SIZE								; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 8										; sh_addralign
	dq 8										; sh_entsize
	
	;
	;	TEXT
	;
	dd 11										; sh_name
	dd 1										; sh_type
	dq 6										; sh_flags
	dq TEXT_SECTION								; sh_addr
	dq TEXT_SECTION								; sh_offset
	dq TEXT_SECTION_SIZE						; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 16										; sh_addralign
	dq 0										; sh_entsize
	
	;
	;	RODATA
	;
	dd 150										; sh_name
	dd SHT_PROGBITS								; sh_type
	dq 0										; sh_flags
	dq RODATA									; sh_addr
	dq RODATA									; sh_offset
	dq RODATA_SIZE								; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 4										; sh_addralign
	dq 0										; sh_entsize
	
	;
	;	INIT_ARRAY
	;
	dd 115										; sh_name
	dd 14										; sh_type
	dq 3										; sh_flags
	dq INIT_ARRAY + 0x200000					; sh_addr
	dq INIT_ARRAY								; sh_offset
	dq INIT_ARRAY_SIZE							; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 8										; sh_addralign
	dq 8										; sh_entsize
	
	;
	;	FINI_ARRAY
	;
	dd 127										; sh_name
	dd 15										; sh_type
	dq 3										; sh_flags
	dq FINI_ARRAY + 0x200000					; sh_addr
	dq FINI_ARRAY								; sh_offset
	dq FINI_ARRAY_SIZE							; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 8										; sh_addralign
	dq 8										; sh_entsize
	
	;
	;	DYNAMIC
	;
	dd 25										; sh_name
	dd 6										; sh_type
	dq 3										; sh_flags
	dq DYNAMIC + 0x200000						; sh_addr
	dq DYNAMIC									; sh_offset
	dq DYNAMIC_SIZE								; sh_size
	dd 3										; sh_link
	dd 0										; sh_info
	dq 8										; sh_addralign
	dq 16										; sh_entsize
	
	;
	;	GOT
	;
	dd 96										; sh_name
	dd 1										; sh_type
	dq 3										; sh_flags
	dq GOT + 0x200000							; sh_addr
	dq GOT										; sh_offset
	dq GOT_SIZE									; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 8										; sh_addralign
	dq 8										; sh_entsize
	
	;
	;	DATA
	;
	dd 144										; sh_name
	dd 1										; sh_type
	dq 3										; sh_flags
	dq DATA + 0x200000							; sh_addr
	dq DATA										; sh_offset
	dq DATA_SIZE								; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 8										; sh_addralign
	dq 0										; sh_entsize
	
	;
	;	BSS
	;
	dd 139										; sh_name
	dd 8										; sh_type
	dq 3										; sh_flags
	dq BSS + 0x200000							; sh_addr
	dq BSS										; sh_offset
	dq 16										; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 8										; sh_addralign
	dq 0										; sh_entsize
	
	;
	;	SYMTAB
	;
	dd 58										; sh_name
	dd 2										; sh_type
	dq 0										; sh_flags
	dq SYMTAB									; sh_addr
	dq SYMTAB									; sh_offset
	dq SYMTAB_SIZE								; sh_size
	dd 18										; sh_link
	dd 19										; sh_info
	dq 8										; sh_addralign
	dq SYMTAB_ENTRY_SIZE						; sh_entsize
	
	;
	;	STRTAB
	;
	dd 50										; sh_name
	dd 3										; sh_type
	dq 0										; sh_flags
	dq STRTAB									; sh_addr
	dq STRTAB									; sh_offset
	dq STRTAB_SIZE								; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 1										; sh_addralign
	dq 0										; sh_entsize
	
	;
	;	SHSTRTAB
	;
	dd 1										; sh_name
	dd 3										; sh_type
	dq 0										; sh_flags
	dq 0										; sh_addr
	dq SHSTRTAB									; sh_offset
	dq SHSTRTAB_SIZE							; sh_size
	dd 0										; sh_link
	dd 0										; sh_info
	dq 1										; sh_addralign
	dq 0										; sh_entsize
	
;
;	SYMTAB
;
align 8

SYMTAB:
	dd 0										; st_name	|
	db 0, 0										; st_info	| st_other
	dw 0										; st_shndx	|
	dq 0, 0										; st_value	| st_size
	
	SYMTAB_ENTRY_SIZE equ $ - SYMTAB
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 1
	dq INTERP, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 2
	dq HASH, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 3
	dq DYNSTR, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 4
	dq DYNSYM, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 5
	dq RELA.DYN, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 6
	dq RELA.PLT, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 7
	dq PLT, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 8
	dq PLT.GOT, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 9
	dq TEXT_SECTION, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 10
	dq RODATA, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 11
	dq INIT_ARRAY, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 12
	dq FINI_ARRAY, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 13
	dq DYNAMIC, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 14
	dq GOT, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 15
	dq DATA, 0
	
	dd 0
	db ELF64_ST_INFO(STB_LOCAL, STT_SECTION), 0
	dw 16
	dq 0, 0
	
	dd 1
	db ELF64_ST_INFO(STB_LOCAL, STT_OBJECT), 0
	dw 14
	dq GOT + 0x200000, 0
	
	dd 23
	db ELF64_ST_INFO(STB_LOCAL, STT_OBJECT), 0
	dw 13
	dq DYNAMIC + 0x200000, 0
		
	dd 32
	db ELF64_ST_INFO(STB_GLOBAL, STT_NOTYPE), 0
	dw 16
	dq BSS + 0x200000, 0
	
	dd 44
	db ELF64_ST_INFO(STB_GLOBAL, STT_NOTYPE), 0
	dw 16
	dq EXTERN_DATA + 0x200000 + 8, 0
	
	dd 49
	db ELF64_ST_INFO(STB_GLOBAL, STT_FUNC), 0
	dw 9
	dq ENTRY, ENTRY_SIZE
	
	dd 56
	db ELF64_ST_INFO(STB_GLOBAL, STT_FUNC), 0
	dw 0
	dq 0, 0
	
	dd 63
	db ELF64_ST_INFO(STB_GLOBAL, STT_FUNC), 0
	dw 0
	dq 0, 0
	
	dd 71
	db ELF64_ST_INFO(STB_GLOBAL, STT_FUNC), 0
	dw 0
	dq 0, 0
	
SYMTAB_SIZE equ $ - SYMTAB
	
;
;	STRTAB
;
STRTAB:
	db 0
	db '_GLOBAL_OFFSET_TABLE_', 0	; 1
	db '_DYNAMIC', 0				; 23
	db '__bss_start', 0				; 32
	db '_end', 0					; 44
	db '_start', 0					; 49
	db 'dlopen', 0					; 56
	db 'dlclose', 0					; 63
	db 'dlsym', 0					; 71
STRTAB_SIZE equ $ - STRTAB

;
;	SHSTRTAB
;
SHSTRTAB:
	db 0
	db '.shstrtab', 0				; 1
	db '.text', 0					; 11
	db '.interp', 0					; 17
	db '.dynamic', 0				; 25
	db '.dynstr', 0					; 34
	db '.dynsym', 0					; 42
	db '.strtab', 0					; 50
	db '.symtab' ,0					; 58
	db '.rela.plt', 0				; 66
	db '.rela.dyn', 0				; 76
	db '.gnu.hash', 0				; 86
	db '.got', 0					; 96
	db '.plt', 0					; 101
	db '.plt.got', 0				; 106
	db '.init_array', 0				; 115
	db '.fini_array', 0				; 127
	db '.bss', 0					; 139
	db '.data', 0					; 144
	db '.rodata', 0					; 150
SHSTRTAB_SIZE equ $ - SHSTRTAB
