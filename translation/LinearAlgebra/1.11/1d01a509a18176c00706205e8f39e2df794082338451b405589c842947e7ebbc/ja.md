```
promote_leaf_eltypes(itr)
```

(おそらくネストされた) iterable オブジェクト `itr` の葉要素の型を昇格させます。`promote_type(typeof(leaf1), typeof(leaf2), ...)` と同等です。現在、数値の葉要素のみをサポートしています。

# 例

```jldoctest
julia> a = [[1,2, [3,4]], 5.0, [6im, [7.0, 8.0]]]
3-element Vector{Any}:
  Any[1, 2, [3, 4]]
 5.0
  Any[0 + 6im, [7.0, 8.0]]

julia> LinearAlgebra.promote_leaf_eltypes(a)
ComplexF64 (alias for Complex{Float64})
```
