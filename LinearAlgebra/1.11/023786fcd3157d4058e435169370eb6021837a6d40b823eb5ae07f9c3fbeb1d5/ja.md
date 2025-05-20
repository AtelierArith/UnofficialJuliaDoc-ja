```
^(b::Number, A::AbstractMatrix)
```

行列の指数関数、$\exp(\log(b)A)$に相当します。

!!! compat "Julia 1.1"
    `Irrational` 数（例えば `ℯ`）を行列に対して累乗するサポートは、Julia 1.1で追加されました。


# 例

```jldoctest
julia> 2^[1 2; 0 3]
2×2 Matrix{Float64}:
 2.0  6.0
 0.0  8.0

julia> ℯ^[1 2; 0 3]
2×2 Matrix{Float64}:
 2.71828  17.3673
 0.0      20.0855
```
