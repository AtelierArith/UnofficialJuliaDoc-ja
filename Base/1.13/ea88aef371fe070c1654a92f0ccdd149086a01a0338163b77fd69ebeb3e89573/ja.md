```julia
complex(A::AbstractArray)
```

配列 `A` の各要素に対応する複素数の値を含む配列を返します。

`complex.(A)` と同等ですが、出力型 `T` を指定した場合の `convert(T, A)` の動作に応じて、戻り値が `A` の全体または一部とメモリを共有することがあります。

# Examples

```jldoctest
julia> complex([1, 2, 3])
3-element Vector{Complex{Int64}}:
 1 + 0im
 2 + 0im
 3 + 0im
```
