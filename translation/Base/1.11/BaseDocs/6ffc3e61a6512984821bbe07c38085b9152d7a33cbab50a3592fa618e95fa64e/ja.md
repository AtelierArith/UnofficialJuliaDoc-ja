```
Matrix{T}(undef, m, n)
```

サイズ `m`×`n` の初期化されていない [`Matrix{T}`](@ref) を構築します。

# 例

```julia-repl
julia> Matrix{Float64}(undef, 2, 3)
2×3 Array{Float64, 2}:
 2.36365e-314  2.28473e-314    5.0e-324
 2.26704e-314  2.26711e-314  NaN

julia> similar(ans, Int32, 2, 2)
2×2 Matrix{Int32}:
 490537216  1277177453
         1  1936748399
```
