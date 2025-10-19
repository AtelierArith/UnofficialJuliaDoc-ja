```julia
memset(dst::Ptr, val, n::Integer) -> Ptr{Cvoid}
```

C標準ライブラリから`memset`を呼び出します。

!!! compat "Julia 1.10"
    `memset`のサポートには少なくともJulia 1.10が必要です。

