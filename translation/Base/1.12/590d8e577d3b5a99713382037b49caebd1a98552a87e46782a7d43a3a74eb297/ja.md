```julia
memmove(dst::Ptr, src::Ptr, n::Integer) -> Ptr{Cvoid}
```

C標準ライブラリから`memmove`を呼び出します。

!!! compat "Julia 1.10"
    `memmove`のサポートには少なくともJulia 1.10が必要です。

