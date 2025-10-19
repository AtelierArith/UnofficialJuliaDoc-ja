```julia
findnz(x::SparseVector)
```

スパースベクトルのような `x` において、保存された（「構造的に非ゼロ」）値のインデックス `I` と値のベクトル `V` からなるタプル `(I, V)` を返します。

# 例

```jldoctest
julia> x = sparsevec([1 2 0; 0 0 3; 0 4 0])
9-element SparseVector{Int64, Int64} with 4 stored entries:
  [1]  =  1
  [4]  =  2
  [6]  =  4
  [8]  =  3

julia> findnz(x)
([1, 4, 6, 8], [1, 2, 4, 3])
```
