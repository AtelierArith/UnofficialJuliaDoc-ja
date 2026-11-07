```julia
realloc(addr::Ptr, size::Integer)::Ptr{Cvoid}
```

C標準ライブラリの`realloc`を呼び出します。

[`free`](@ref)のドキュメントにある、[`malloc`](@ref)から最初に取得したメモリにのみ使用するようにという警告を参照してください。
