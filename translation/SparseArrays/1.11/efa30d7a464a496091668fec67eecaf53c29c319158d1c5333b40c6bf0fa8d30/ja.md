```
sparse(I, J, V,[ m, n, combine])
```

次のように、`S[I[k], J[k]] = V[k]` となる `m x n` のスパース行列 `S` を作成します。`combine` 関数は重複を結合するために使用されます。`m` と `n` が指定されていない場合、それぞれ `maximum(I)` と `maximum(J)` に設定されます。`combine` 関数が指定されていない場合、`combine` はデフォルトで `+` になりますが、`V` の要素がブール値の場合は `combine` はデフォルトで `|` になります。`I` のすべての要素は `1 <= I[k] <= m` を満たさなければならず、`J` のすべての要素は `1 <= J[k] <= n` を満たさなければなりません。`(I, J, V)` の数値ゼロは構造的な非ゼロとして保持されます。数値ゼロを削除するには、[`dropzeros!`](@ref) を使用してください。

追加のドキュメントと専門的なドライバーについては、`SparseArrays.sparse!` を参照してください。

# 例

```jldoctest
julia> Is = [1; 2; 3];

julia> Js = [1; 2; 3];

julia> Vs = [1; 2; 3];

julia> sparse(Is, Js, Vs)
3×3 SparseMatrixCSC{Int64, Int64} with 3 stored entries:
 1  ⋅  ⋅
 ⋅  2  ⋅
 ⋅  ⋅  3
```
