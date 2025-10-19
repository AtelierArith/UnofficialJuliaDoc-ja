```julia
min(x, y, ...)
```

引数の最小値を [`isless`](@ref) に基づいて返します。引数のいずれかが [`missing`](@ref) の場合、`missing` を返します。コレクションから最小要素を取得するには、[`minimum`](@ref) 関数も参照してください。

# 例

```jldoctest
julia> min(2, 5, 1)
1

julia> min(4, missing, 6)
missing
```
