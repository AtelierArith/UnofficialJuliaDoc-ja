```julia
sparsevec(I, V, [m, combine])
```

長さ `m` のスパースベクトル `S` を作成し、`S[I[k]] = V[k]` となるようにします。重複は `combine` 関数を使用して結合され、`combine` 引数が提供されていない場合はデフォルトで `+` になります。ただし、`V` の要素がブール値の場合は、`combine` はデフォルトで `|` になります。

# 例

```jldoctest
julia> II = [1, 3, 3, 5]; V = [0.1, 0.2, 0.3, 0.2];

julia> sparsevec(II, V)
5-element SparseVector{Float64, Int64} with 3 stored entries:
  [1]  =  0.1
  [3]  =  0.5
  [5]  =  0.2

julia> sparsevec(II, V, 8, -)
8-element SparseVector{Float64, Int64} with 3 stored entries:
  [1]  =  0.1
  [3]  =  -0.1
  [5]  =  0.2

julia> sparsevec([1, 3, 1, 2, 2], [true, true, false, false, false])
3-element SparseVector{Bool, Int64} with 3 stored entries:
  [1]  =  1
  [2]  =  0
  [3]  =  1
```
