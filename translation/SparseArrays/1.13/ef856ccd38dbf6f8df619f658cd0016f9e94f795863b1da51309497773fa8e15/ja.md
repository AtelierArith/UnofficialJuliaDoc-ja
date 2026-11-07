```julia
sparse(I, J, V,[ m, n, combine])
```

次元が `m x n` で、`S[I[k], J[k]] = V[k]` となる疎行列 `S` を作成します。重複要素の結合には `combine` 関数を使用します。`m` と `n` が指定されていない場合、それぞれ `maximum(I)` と `maximum(J)` に設定されます。`combine` 関数が指定されていない場合、`combine` の既定値は `+` です。ただし、`V` の要素が Boolean の場合は、`combine` の既定値は `|` になります。`I` のすべての要素は `1 <= I[k] <= m` を満たし、`J` のすべての要素は `1 <= J[k] <= n` を満たす必要があります。(`I`, `J`, `V`) 内の数値ゼロは構造上の非ゼロ要素として保持されます。数値ゼロを削除するには、[`dropzeros!`](@ref) を使用してください。

詳しいドキュメントとエキスパート向けドライバーについては、`SparseArrays.sparse!` を参照してください。

# Examples

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
