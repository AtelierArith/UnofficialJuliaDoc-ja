```julia
Sys.free_physical_memory()
```

Get the free memory of the system in bytes. The entire amount may not be available to the current process; use `Sys.free_memory()` for the actually available amount.
