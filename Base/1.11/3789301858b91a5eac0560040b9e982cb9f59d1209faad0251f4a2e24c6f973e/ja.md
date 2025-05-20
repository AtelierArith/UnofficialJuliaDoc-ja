```
skipmissing(itr)
```

`itr`内の要素を反復処理し、[`missing`](@ref)値をスキップするイテレータを返します。返されるオブジェクトは、`itr`がインデックス可能であれば、`itr`のインデックスを使用してインデックス付けできます。欠損値に対応するインデックスは無効であり、[`keys`](@ref)および[`eachindex`](@ref)によってスキップされ、使用しようとすると`MissingException`がスローされます。

[`collect`](@ref)を使用して、`itr`内の非`missing`値を含む`Array`を取得します。`itr`が多次元配列であっても、入力の次元を保持しながら欠損を削除することは不可能なため、結果は常に`Vector`になります。

他にも[`coalesce`](@ref)、[`ismissing`](@ref)、[`something`](@ref)があります。

# 例

```jldoctest
julia> x = skipmissing([1, missing, 2])
skipmissing(Union{Missing, Int64}[1, missing, 2])

julia> sum(x)
3

julia> x[1]
1

julia> x[2]
ERROR: MissingException: the value at index (2,) is missing
[...]

julia> argmax(x)
3

julia> collect(keys(x))
2-element Vector{Int64}:
 1
 3

julia> collect(skipmissing([1, missing, 2]))
2-element Vector{Int64}:
 1
 2

julia> collect(skipmissing([1 missing; 2 missing]))
2-element Vector{Int64}:
 1
 2
```
