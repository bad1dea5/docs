# Handles

With Microsoft's compiler and linker, to get the current module handle, you can use

```cpp
extern "C" IMAGE_DOS_HEADER __ImageBase;
```

For the current process
```cpp
(void*)-1;
```

For the current thread
```cpp
(void*)-2;
```
