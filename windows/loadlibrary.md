# LoadLibrary

```cpp
LIST_ENTRY* list = reinterpret_cast<LIST_ENTRY*>(PEB()->Ldr->InMemoryOrderModuleList.Flink);
LDR_DATA_TABLE_ENTRY* entry = reinterpret_cast<LDR_DATA_TABLE_ENTRY*>(list);

while (entry->FullDllName.Buffer)
{
  //
  
  list = list->Flink;
  entry = reinterpret_cast<LDR_DATA_TABLE_ENTRY*>(list);
}
```
