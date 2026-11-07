```julia
memset(dst::Ptr, val, n::Integer)::Ptr{Cvoid}
```

C標準ライブラリの`memset`を呼び出します。

!!! compat "Julia 1.10"
    `memset`のサポートには、Julia 1.10以降が必要です。

