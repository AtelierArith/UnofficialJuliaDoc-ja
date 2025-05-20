```
length(collection) -> 整数
```

コレクション内の要素の数を返します。

インデックス可能なコレクションの最後の有効なインデックスを取得するには、[`lastindex`](@ref)を使用してください。

関連情報: [`size`](@ref), [`ndims`](@ref), [`eachindex`](@ref).

# 例

```jldoctest
julia> length(1:5)
5

julia> length([1, 2, 3, 4])
4

julia> length([1 2; 3 4])
4
```
