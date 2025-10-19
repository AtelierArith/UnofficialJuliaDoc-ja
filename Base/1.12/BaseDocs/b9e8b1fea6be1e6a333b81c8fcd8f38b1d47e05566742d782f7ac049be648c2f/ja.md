```julia
Vector{T}(missing, m)
```

長さ `m` の [`Vector{T}`](@ref) を構築し、[`missing`](@ref) エントリで初期化します。要素型 `T` はこれらの値を保持できる必要があります。すなわち、`Missing <: T` です。

# 例

```jldoctest
julia> Vector{Union{Missing, String}}(missing, 2)
2-element Vector{Union{Missing, String}}:
 missing
 missing
```
