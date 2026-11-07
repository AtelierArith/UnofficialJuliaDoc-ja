```julia
ntuple(f, n::Integer)
```

長さが `n` のタプルを作成します。各要素は、要素のインデックスを `i` として、`f(i)` と計算します。

# Examples

```jldoctest
julia> ntuple(i -> 2*i, 4)
(2, 4, 6, 8)
```
