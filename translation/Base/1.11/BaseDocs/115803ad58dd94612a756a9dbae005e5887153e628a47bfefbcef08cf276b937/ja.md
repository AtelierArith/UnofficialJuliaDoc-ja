```
Vector{T}(undef, n)
```

長さ `n` の初期化されていない [`Vector{T}`](@ref) を構築します。

# 例

```julia-repl
julia> Vector{Float64}(undef, 3)
3-element Array{Float64, 1}:
 6.90966e-310
 6.90966e-310
 6.90966e-310
```
