```julia
realloc(addr::Ptr, size::Integer)::Ptr{Cvoid}
```

C標準ライブラリの`realloc`を呼び出します。

[`free`](@ref)のドキュメントにある警告を参照してください。この関数は、もともと[`malloc`](@ref)から取得したメモリに対してのみ使用してください。
