```
A / B
```

行列の右除算: `A / B` は `(B' \ A')'` に相当し、ここで [`\`](@ref) は左除算演算子です。正方行列の場合、結果 `X` は `A == X*B` となります。

関連情報: [`rdiv!`](@ref).

# 例

```jldoctest
julia> A = Float64[1 4 5; 3 9 2]; B = Float64[1 4 2; 3 4 2; 8 7 1];

julia> X = A / B
2×3 Matrix{Float64}:
 -0.65   3.75  -1.2
  3.25  -2.75   1.0

julia> isapprox(A, X*B)
true

julia> isapprox(X, A*pinv(B))
true
```
