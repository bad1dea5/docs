# Dynamic Linker

### dlopen()

> The function dlopen() loads the dynamic library file named by the null-terminated string filename and returns an opaque "handle" for the dynamic library. If filename is NULL, then the returned handle is for the main program.

### dlsym()

> The function dlsym() takes a "handle" of a dynamic library returned by dlopen() and the null-terminated symbol name, returning the address where that symbol is loaded into memory.

The four functions [dlopen(), dlsym(), dlclose(), dlerror()](https://linux.die.net/man/3/dlopen) implement the interface to the dynamic linking loader. 

## _DYNAMIC

> The `.dynamic` section contains a series of structures that hold relevant dynamic linking information.
> The `d_tag` member controls the interpretation of `d_un`.

```c
typedef struct
{
  Elf64_Sxwordd_tag;  // uint64_t
  union
  {
    Elf64_Xwordd_val; // uint64_t
    Elf64_Addrd_ptr;  // uint64_t
  } d_un;
}
Elf64_Dyn;

extern Elf64_Dyn _DYNAMIC[];
```
Example of dynamic section:
```
$ readelf -d example

Dynamic section at offset 0xe80 contains 17 entries:
  Tag        Type                         Name/Value
 0x0000000000000001 (NEEDED)             Shared library: [libdl.so.2]
 0x000000006ffffef5 (GNU_HASH)           0x240
 0x0000000000000005 (STRTAB)             0x290
 0x0000000000000006 (SYMTAB)             0x260
 0x000000000000000a (STRSZ)              31 (bytes)
 0x000000000000000b (SYMENT)             24 (bytes)
 0x0000000000000015 (DEBUG)              0x0
 0x0000000000000003 (PLTGOT)             0x200fe0
 0x0000000000000007 (RELA)               0x2d8
 0x0000000000000008 (RELASZ)             24 (bytes)
 0x0000000000000009 (RELAENT)            24 (bytes)
 0x000000000000001e (FLAGS)              BIND_NOW
 0x000000006ffffffb (FLAGS_1)            Flags: NOW PIE
 0x000000006ffffffe (VERNEED)            0x2b8
 0x000000006fffffff (VERNEEDNUM)         1
 0x000000006ffffff0 (VERSYM)             0x2b0
 0x0000000000000000 (NULL)               0x0
```

```cpp
// load address: 0xf4000
// dynamic offset: 0xe80

extern Elf64_Dyn _DYNAMIC[];
Elf64_Dyn* dynamic = reinterpret_cast<Elf64_Dyn*>(_DYNAMIC);

// dynamic = 0xf4e80 (== _DYNAMIC)
```

## DT_DEBUG

Name | Value | d_un | Description
--- | --- | --- | ---
DT_DEBUG | 21 | d_ptr | Reserved for debugging use.

> The run-time linker exposes a rendezvous structure to allow debuggers
> to interface with it.  This structure, r_debug, is defined in link.h.
> If the executable's dynamic section has a DT_DEBUG element, the
> run-time linker sets that element's value to the address where this
> structure can be found.

So once in memory, the run-time linker sets the `DT_DEBUG` pointer (`d_ptr`) to the `r_debug` struct.

## r_debug

```c
struct r_debug
{
  int r_version;		/* Version number for this protocol.  */

  struct link_map *r_map;	/* Head of the chain of loaded objects.  */

  /* This is the address of a function internal to the run-time linker,
   that will always be called when the linker begins to map in a
   library or unmap it, and again when the mapping change is complete.
   The debugger can set a breakpoint at this address if it wants to
   notice shared object mapping changes.  */
  Elf64_Addr r_brk;
  
  enum
  {
    /* This state value describes the mapping change taking place when
    the `r_brk' address is called.  */
    
    RT_CONSISTENT,		/* Mapping change is complete.  */
    RT_ADD,			/* Beginning to add a new object.  */
    RT_DELETE		/* Beginning to remove an object mapping.  */
  } r_state;

  Elf64_Addr r_ldbase;	/* Base address the linker is loaded at.  */

};
```

## link_map

```c
struct link_map
{
  /* These first few members are part of the protocol with the debugger.  */

  Elf64_Addr l_addr;  /* Difference between the address in the ELF file and the addresses in memory.  */
  char *l_name;       /* Absolute file name object was found in.  */
  Elf64_Dyn *l_ld;    /* Dynamic section of the shared object.  */
  struct link_map *l_next, *l_prev; /* Chain of loaded objects.  */

  /* All following members are internal to the dynamic linker.
      They may change without notice.  */

  ...
};
```

The first item in the array points to the application itself, and then you can iterate over the loaded modules.
The last one in the list will be NULL.

## Example

```cpp
extern Elf64_Dyn _DYNAMIC[];

using LinkMap = struct link_map;
using Debug = struct r_debug;

Elf64_Dyn* dyn = reinterpret_cast<Elf64_Dyn*>(_DYNAMIC);
Debug* dbg = nullptr;
LinkMap* map = nullptr;

while(dyn->d_tag)
{
  if (dyn->d_tag == DT_DEBUG)
  {
    dbg = reinterpret_cast<Debug*>(dyn->d_un.d_ptr);
    map = reinterpret_cast<LinkMap*>(dbg->r_map);
    
    // map now points to application
    
    while(map)
    {
      if(strcmp(map->l_name, "libc.so.6"))
        return map->l_addr;
        
      map = map->l_next;
    }
  }
  dyn++;
}

void* handle = map->l_addr;
```

# Next

Now that we have the handle, we can start getting headers, sections and symbols.

```cpp
Elf64_Ehdr* ehdr = reinterpret_cast<Elf64_Ehdr*>(handle);
Elf64_Phdr* phdr = reinterpret_cast<Elf64_Phdr*>(handle + ehdr->e_phoff);
Elf64_Shdr* phdr = reinterpret_cast<Elf64_Shdr*>(handle + ehdr->e_shoff);
```

Although I could get the section header, iterate over it, and see it in memory, it would error with `segmentation fault` 
when I tried to read from it.

Iterate over program header until `PT_DYNAMIC` is found. `p_vddr` will point to the dynamic section.
Again iterate over the dynamic section. `DT_STRTAB` points to the address of the dynamic string table.
`DT_SYMTAB` points to address of the dynamic symbol table.

```cpp
const char* strtab = reinterpret_cast<PCSTR>(dynamic->d_un.d_ptr);
Elf64_Sym* symtab = reinterpret_cast<Elf64_Sym*>(dynamic->d_un.d_ptr);
```

## .dynsym

```cpp
typedef  struct
{
  Elf64_Word st_name;     /*  Symbol  name  */
  unsigned char st_info;  /*  Type  and  Binding  attributes  */
  unsigned char st_other; /*  Reserved  */
  Elf64_Half st_shndx;    /*  Section  table  index  */
  Elf64_Addr st_value;    /*  Symbol  value  */
  Elf64_Xword st_size;    /*  Size  of  object  (e.g.,  common)  */
} Elf64_Sym;
```

Because of the problem with reading the section headers, we need to find another way to find the size
of the `.dynsym`. From the default linker script (via `-Wl,--verbose`):

```
.dynsym         : { *(.dynsym) }
.dynstr         : { *(.dynstr) }
```

`.dynstr` comes after `.dynsym`. So to get the size of the section

```cpp
size_t count = (ptrdiff_t(strtab) - ptrdiff_t(symbol) / sizeof(Elf64_Sym));
```

and then iterate through the symbols.

```cpp
for (auto i = 0; i < count; i++)
{
  if(!strcmp(strtab + symbol->st_name, "malloc"))
    return (handle + symbol->st_value);

  symbol++;
}
```

### Reference
- [r_debug](https://github.com/lattera/glibc/blob/master/elf/link.h)
- [link_map](https://github.com/lattera/glibc/blob/master/include/link.h)
- [ELF64 Spec](https://uclibc.org/docs/elf-64-gen.pdf)
