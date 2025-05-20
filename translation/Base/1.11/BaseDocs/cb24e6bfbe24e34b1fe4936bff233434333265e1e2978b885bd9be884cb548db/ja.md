```
Array{T}(nothing, dims)
Array{T,N}(nothing, dims)
```

`T`型の要素を含む`N`次元の[`Array`](@ref)を構築し、[`nothing`](@ref)エントリで初期化します。要素型`T`はこれらの値を保持できる必要があります。すなわち、`Nothing <: T`です。

# 例

```jldoctest
julia> Array{Union{Nothing, String}}(nothing, 2)
2-element Vector{Union{Nothing, String}}:
 nothing
 nothing

julia> Array{Union{Nothing, Int}}(nothing, 2, 3)
2×3 Matrix{Union{Nothing, Int64}}:
 nothing  nothing  nothing
 nothing  nothing  nothing
```
