```julia
min(x, y, ...)
```

[`isless`](@ref)に基づいて、引数の最小値を返します。引数のいずれかが[`missing`](@ref)の場合は、`missing`を返します。コレクションから最小の要素を取得するには、[`minimum`](@ref)関数も参照してください。

# Examples

```jldoctest
julia> min(2, 5, 1)
1

julia> min(4, missing, 6)
missing
```
