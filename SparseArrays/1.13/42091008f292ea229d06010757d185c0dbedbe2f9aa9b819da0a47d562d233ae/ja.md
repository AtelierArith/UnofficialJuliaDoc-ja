```julia
sparsevec(d::Dict, [m])
```

辞書のキーを非ゼロ要素のインデックス、辞書の値を非ゼロ要素の値として、長さが `m` の疎ベクトルを作成します。

# Examples

```jldoctest
julia> sparsevec(Dict(1 => 3, 2 => 2))
2-element SparseVector{Int64, Int64} with 2 stored entries:
  [1]  =  3
  [2]  =  2
```
