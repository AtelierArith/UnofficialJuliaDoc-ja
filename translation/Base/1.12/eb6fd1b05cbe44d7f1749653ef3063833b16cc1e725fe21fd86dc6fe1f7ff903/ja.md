```julia
require_one_based_indexing(A::AbstractArray)
require_one_based_indexing(A,B...)
```

引数のいずれかのインデックスが、任意の軸に沿って `1` 以外のもので始まる場合、`ArgumentError` をスローします。詳細は [`has_offset_axes`](@ref) を参照してください。

!!! compat "Julia 1.2"
    この関数は少なくとも Julia 1.2 を必要とします。

