```julia
Matrix{T}(missing, m, n)
```

[`Matrix{T}`](@ref)を、`m`×`n`のサイズで構築し、[`missing`](@ref)の要素で初期化します。要素型`T`は、これらの値を格納できる必要があります。つまり、`Missing <: T`です。

# Examples

```jldoctest
julia> Matrix{Union{Missing, String}}(missing, 2, 3)
2×3 Matrix{Union{Missing, String}}:
 missing  missing  missing
 missing  missing  missing
```
