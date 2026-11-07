```julia
^(b::Number, A::AbstractMatrix)
```

行列指数関数。``\exp(\log(b)A)``と等価です。

!!! compat "Julia 1.1"
    `Irrational`の数値（`ℯ`など）を行列に累乗する機能は、Julia 1.1で追加されました。


# Examples

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
