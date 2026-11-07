```julia
det_bareiss!(M)
```

[Bareiss Algorithm](https://en.wikipedia.org/wiki/Bareiss_algorithm)を使用し、インプレース操作で行列式を計算します。

# Examples

```jldoctest
julia> M = [1 0; 2 2]
2×2 Matrix{Int64}:
 1  0
 2  2

julia> LinearAlgebra.det_bareiss!(M)
2
```
