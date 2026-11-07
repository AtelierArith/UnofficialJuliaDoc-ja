```julia
Sys.total_memory()
```

Get the total memory in RAM (including that which is currently used) in bytes. This amount may be constrained, e.g., by Linux control groups. For the unconstrained amount, see `Sys.total_physical_memory()`.
