```julia
findnz(x::SparseVector)
```

タプル `(I, V)` を返します。ここで、`I` は疎ベクトルのような `x` に格納されている（「構造的に非ゼロ」の）値のインデックスで、`V` は値を格納したベクトルです。

# Examples

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
