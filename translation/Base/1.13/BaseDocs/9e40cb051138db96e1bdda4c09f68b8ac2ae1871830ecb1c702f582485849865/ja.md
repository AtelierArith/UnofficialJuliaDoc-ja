```julia
Array{T}(missing, dims)
Array{T,N}(missing, dims)
```

`N` 次元の [`Array`](@ref) を構築します。要素の型は `T` で、[`missing`](@ref) 個のエントリで初期化します。要素型 `T` は、これらの値を格納できる必要があります。つまり、`Missing <: T` です。

# Examples

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
