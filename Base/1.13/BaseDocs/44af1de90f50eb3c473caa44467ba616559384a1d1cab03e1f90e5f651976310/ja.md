```julia
Matrix{T}(nothing, m, n)
```

[`Matrix{T}`](@ref)を`m`×`n`のサイズで作成し、[`nothing`](@ref)の要素で初期化します。要素型`T`は、これらの値を格納できる必要があります。つまり、`Nothing <: T`です。

# Examples

```jldoctest
julia> Matrix{Union{Nothing, String}}(nothing, 2, 3)
2×3 Matrix{Union{Nothing, String}}:
 nothing  nothing  nothing
 nothing  nothing  nothing
```
