```
Vector{T}(nothing, m)
```

長さ `m` の [`Vector{T}`](@ref) を、[`nothing`](@ref) エントリで初期化して構築します。要素型 `T` はこれらの値を保持できる必要があります。すなわち、`Nothing <: T` です。

# 例

```jldoctest
julia> Vector{Union{Nothing, String}}(nothing, 2)
2-element Vector{Union{Nothing, String}}:
 nothing
 nothing
```
