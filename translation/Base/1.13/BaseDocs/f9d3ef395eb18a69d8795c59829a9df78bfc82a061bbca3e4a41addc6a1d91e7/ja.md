```julia
Vector{T}(missing, m)
```

長さが`m`で、[`missing`](@ref)の要素で初期化された[`Vector{T}`](@ref)を構築します。要素型`T`は、これらの値を格納できる必要があります。つまり、`Missing <: T`です。

# Examples

```jldoctest
julia> Vector{Union{Missing, String}}(missing, 2)
2-element Vector{Union{Missing, String}}:
 missing
 missing
```
