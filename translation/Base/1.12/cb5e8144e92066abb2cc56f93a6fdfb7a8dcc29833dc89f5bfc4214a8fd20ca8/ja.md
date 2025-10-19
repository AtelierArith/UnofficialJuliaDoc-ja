```julia
max(x, y, ...)
```

引数の最大値を [`isless`](@ref) に基づいて返します。引数のいずれかが [`missing`](@ref) の場合、`missing` を返します。コレクションから最大要素を取得するには、[`maximum`](@ref) 関数も参照してください。

# 例

```jldoctest
julia> max(2, 5, 1)
5

julia> max(5, missing, 6)
missing
```
