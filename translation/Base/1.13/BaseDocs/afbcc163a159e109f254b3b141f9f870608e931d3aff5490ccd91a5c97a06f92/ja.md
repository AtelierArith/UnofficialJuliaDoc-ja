```julia
Memory{T}(undef, n)
```

長さが`n`の、未初期化の[`Memory{T}`](@ref)を構築します。長さが0のMemoryオブジェクトは、そこから到達可能な可変コンテンツが存在しないため、エイリアスになることがあります。

# Examples

```julia-repl
julia> Memory{Float64}(undef, 3)
3-element Memory{Float64}:
 6.90966e-310
 6.90966e-310
 6.90966e-310
```
