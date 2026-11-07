```julia
deleteat!(a::Vector, i::Integer)
```

指定した`i`の項目を削除し、変更後の`a`を返します。後続の項目は、空いた位置を埋めるように移動します。

関連項目: [`keepat!`](@ref)、[`delete!`](@ref)、[`popat!`](@ref)、[`splice!`](@ref)。

# Examples

```jldoctest
julia> deleteat!([6, 5, 4, 3, 2, 1], 2)
5-element Vector{Int64}:
 6
 4
 3
 2
 1
```
