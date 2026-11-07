```julia
length(collection)::Integer
```

コレクション内の要素数を返します。

インデックスでアクセスできるコレクションの最後の有効なインデックスを取得するには、[`lastindex`](@ref)を使用してください。

関連項目: [`size`](@ref)、[`ndims`](@ref)、[`eachindex`](@ref)。

# Examples

```jldoctest
julia> length(1:5)
5

julia> length([1, 2, 3, 4])
4

julia> length([1 2; 3 4])
4
```
