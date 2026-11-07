```julia
typejoin(T, S, ...)
```

`T`型と`S`型の最も近い共通祖先、つまり両方が継承する型のうち最も狭いものを返します。追加の可変長引数についても再帰的に処理します。

# Examples

```jldoctest
julia> typejoin(Int, Float64)
Real

julia> typejoin(Int, Float64, ComplexF32)
Number
```
