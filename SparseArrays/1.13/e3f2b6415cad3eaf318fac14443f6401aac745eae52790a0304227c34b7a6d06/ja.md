```julia
sparsevec(A)
```

ベクトル `A` を、長さ `m` の疎ベクトルに変換します。`A` 内の数値的なゼロは、構造的なゼロに変換されます。

# Examples

```jldoctest
julia> sparsevec([1.0, 2.0, 0.0, 0.0, 3.0, 0.0])
6-element SparseVector{Float64, Int64} with 3 stored entries:
  [1]  =  1.0
  [2]  =  2.0
  [5]  =  3.0
```
