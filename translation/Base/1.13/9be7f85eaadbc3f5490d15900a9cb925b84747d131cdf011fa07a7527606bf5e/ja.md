```julia
memmove(dst::Ptr, src::Ptr, n::Integer)::Ptr{Cvoid}
```

C標準ライブラリの`memmove`を呼び出します。

!!! compat "Julia 1.10"
    `memmove`のサポートには、Julia 1.10以降が必要です。

