```julia
Array{T}(nothing, dims)
Array{T,N}(nothing, dims)
```

`N`次元の[`Array`](@ref)を作成します。要素の型は`T`とし、[`nothing`](@ref)の値で初期化します。要素型の`T`は、これらの値を格納できる必要があります。つまり、`Nothing <: T`です。

# Examples

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
