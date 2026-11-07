```julia
copy(F::UmfpackLU, [ws::UmfpackWS])::UmfpackLU
```

A shallow copy of UmfpackLU to use in multithreaded solve applications. This function duplicates the working space, control, info and lock fields.
