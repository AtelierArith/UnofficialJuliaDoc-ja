```julia
realloc(addr::Ptr, size::Integer) -> Ptr{Cvoid}
```

C標準ライブラリから`realloc`を呼び出します。

[`malloc`](@ref)から元々取得したメモリに対してのみ使用することに関する警告は、[`free`](@ref)のドキュメントを参照してください。
