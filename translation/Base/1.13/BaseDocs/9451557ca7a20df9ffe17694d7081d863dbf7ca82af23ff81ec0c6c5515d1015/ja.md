```julia
Vector{T}(undef, n)
```

長さ `n` の未初期化の [`Vector{T}`](@ref) を構築します。

# Examples

```julia-repl
julia> Vector{Float64}(undef, 3)
3-element Vector{Float64}:
 6.90966e-310
 6.90966e-310
 6.90966e-310
```
