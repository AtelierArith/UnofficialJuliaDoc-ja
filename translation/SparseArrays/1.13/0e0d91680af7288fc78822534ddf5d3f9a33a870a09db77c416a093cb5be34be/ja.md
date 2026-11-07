```julia
dropzeros!(x::AbstractCompressedVector)
```

`x`から、格納されている数値のゼロを削除します。

非破壊版については、[`dropzeros`](@ref)を参照してください。アルゴリズムの詳細については、`fkeep!`を参照してください。
