```julia
promote_leaf_eltypes(itr)
```

（入れ子になっている場合もある）反復可能オブジェクト `itr` の葉要素の型を昇格します。`promote_type(typeof(leaf1), typeof(leaf2), ...)` と同等です。現在は数値の葉要素のみをサポートしています。

# Examples

```jldoctest
julia> a = [[1,2, [3,4]], 5.0, [6im, [7.0, 8.0]]]
3-element Vector{Any}:
  Any[1, 2, [3, 4]]
 5.0
  Any[0 + 6im, [7.0, 8.0]]

julia> LinearAlgebra.promote_leaf_eltypes(a)
ComplexF64 (alias for Complex{Float64})
```
