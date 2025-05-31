```
Memory{T}(undef, n)
```

初期化されていない [`Memory{T}`](@ref) を長さ `n` で構築します。長さ 0 のすべての Memory オブジェクトは、そこから到達可能な可変コンテンツがないため、エイリアスする可能性があります。

# 例

```julia-repl
julia> Memory{Float64}(undef, 3)
3-element Memory{Float64}:
 6.90966e-310
 6.90966e-310
 6.90966e-310
```
