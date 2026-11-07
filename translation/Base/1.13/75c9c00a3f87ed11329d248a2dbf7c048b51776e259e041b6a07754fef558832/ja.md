```julia
max(x, y, ...)
```

[`isless`](@ref)に関して、引数の最大値を返します。引数のいずれかが[`missing`](@ref)の場合は、`missing`を返します。コレクションから最大の要素を取得するには、[`maximum`](@ref)関数も参照してください。

# Examples

```jldoctest
julia> max(2, 5, 1)
5

julia> max(5, missing, 6)
missing
```
