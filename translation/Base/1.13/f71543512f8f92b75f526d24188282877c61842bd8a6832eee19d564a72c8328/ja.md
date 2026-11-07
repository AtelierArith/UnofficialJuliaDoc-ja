```julia
repeat(A::AbstractArray, counts::Integer...)
```

各次元で指定された回数だけ配列 `A` を繰り返して、配列を構築します。回数は `counts` で指定します。

関連項目: [`fill`](@ref)、[`Iterators.repeated`](@ref)、[`Iterators.cycle`](@ref)。

# Examples

```jldoctest
julia> repeat([1, 2, 3], 2)
6-element Vector{Int64}:
 1
 2
 3
 1
 2
 3

julia> repeat([1, 2, 3], 2, 3)
6×3 Matrix{Int64}:
 1  1  1
 2  2  2
 3  3  3
 1  1  1
 2  2  2
 3  3  3
```
