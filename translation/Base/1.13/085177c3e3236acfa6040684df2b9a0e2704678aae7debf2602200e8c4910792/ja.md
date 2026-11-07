```julia
typejoin(T, S, ...)
```

`T` と `S` の最も近い共通祖先、つまり両方が継承する型のうち最も限定的なものを返します。追加の可変長引数がある場合は、再帰的に処理します。

# Examples

```jldoctest
julia> typejoin(Int, Float64)
Real

julia> typejoin(Int, Float64, ComplexF32)
Number
```
