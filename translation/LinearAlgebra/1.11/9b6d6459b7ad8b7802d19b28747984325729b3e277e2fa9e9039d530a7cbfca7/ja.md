```
det_bareiss!(M)
```

行列の行列式を、インプレース操作を使用して[バレイスアルゴリズム](https://en.wikipedia.org/wiki/Bareiss_algorithm)を用いて計算します。

# 例

```jldoctest
julia> M = [1 0; 2 2]
2×2 Matrix{Int64}:
 1  0
 2  2

julia> LinearAlgebra.det_bareiss!(M)
2
```
