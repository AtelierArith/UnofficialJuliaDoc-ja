```
Array{T}(missing, dims)
Array{T,N}(missing, dims)
```

`T`型の要素を持つ`N`次元の[`Array`](@ref)を構築し、[`missing`](@ref)エントリで初期化します。要素型`T`はこれらの値を保持できる必要があります。すなわち、`Missing <: T`です。

# 例

```jldoctest
julia> Array{Union{Missing, String}}(missing, 2)
2-element Vector{Union{Missing, String}}:
 missing
 missing

julia> Array{Union{Missing, Int}}(missing, 2, 3)
2×3 Matrix{Union{Missing, Int64}}:
 missing  missing  missing
 missing  missing  missing
```
