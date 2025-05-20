```
logdet(M)
```

行列式の対数。`log(det(M))`と同等ですが、精度が向上し、オーバーフロー/アンダーフローを回避することができます。

# 例

```jldoctest
julia> M = [1 0; 2 2]
2×2 Matrix{Int64}:
 1  0
 2  2

julia> logdet(M)
0.6931471805599453

julia> logdet(Matrix(I, 3, 3))
0.0
```
