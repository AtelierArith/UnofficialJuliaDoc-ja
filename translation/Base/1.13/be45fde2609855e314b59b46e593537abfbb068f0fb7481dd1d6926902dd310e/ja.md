```julia
memcpy(dst::Ptr, src::Ptr, n::Integer)::Ptr{Cvoid}
```

C標準ライブラリの`memcpy`を呼び出します。

!!! compat "Julia 1.10"
    `memcpy`のサポートには、Julia 1.10以降が必要です。

