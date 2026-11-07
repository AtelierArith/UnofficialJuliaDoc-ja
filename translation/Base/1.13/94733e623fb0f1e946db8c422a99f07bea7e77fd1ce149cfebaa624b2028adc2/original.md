```julia
securezero!(o)
```

`securezero!` fills the memory associated with an object `o` with zeros. Unlike `fill!(o,0)` and similar code, which might be optimized away by the compiler for objects about to be discarded, the `securezero!` function will always be called.
