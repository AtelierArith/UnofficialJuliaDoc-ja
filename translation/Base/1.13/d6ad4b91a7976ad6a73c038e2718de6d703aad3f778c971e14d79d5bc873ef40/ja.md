```julia
memcmp(a::Ptr, b::Ptr, n::Integer)::Int
```

C標準ライブラリの`memcmp`を呼び出します。

!!! compat "Julia 1.10"
    `memcmp`のサポートには、Julia 1.9以降が必要です。

