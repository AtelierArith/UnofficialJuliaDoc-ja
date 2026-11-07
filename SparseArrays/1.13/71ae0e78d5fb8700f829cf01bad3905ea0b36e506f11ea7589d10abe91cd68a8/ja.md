```julia
sparsevec(I, V, [m, combine])
```

長さが`m`で、`S[I[k]] = V[k]`となる疎ベクトル`S`を作成します。重複する要素は`combine`関数でまとめられます。`combine`引数を指定しない場合、既定値は`+`です。ただし、`V`の要素がブール値の場合、`combine`の既定値は`|`です。

# Examples

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
