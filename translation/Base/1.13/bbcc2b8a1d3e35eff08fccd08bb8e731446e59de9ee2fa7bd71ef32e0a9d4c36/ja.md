```julia
require_one_based_indexing(A::AbstractArray)
require_one_based_indexing(A,B...)
```

いずれかの引数のインデックスが、どの軸でも`1`以外から始まる場合は、`ArgumentError`をスローします。[`has_offset_axes`](@ref)も参照してください。

!!! compat "Julia 1.2"
    この関数を使用するには、Julia 1.2以降が必要です。

