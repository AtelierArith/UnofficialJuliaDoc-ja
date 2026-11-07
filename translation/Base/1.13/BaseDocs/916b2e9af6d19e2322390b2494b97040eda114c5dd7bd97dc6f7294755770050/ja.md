```julia
Vector{T}(nothing, m)
```

長さが`m`で、[`nothing`](@ref)で初期化された[`Vector{T}`](@ref)を構築します。要素型`T`は、これらの値を格納できる必要があります。つまり、`Nothing <: T`です。

# Examples

```jldoctest
julia> Vector{Union{Nothing, String}}(nothing, 2)
2-element Vector{Union{Nothing, String}}:
 nothing
 nothing
```
