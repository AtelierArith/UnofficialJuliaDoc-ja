```
deleteat!(a::Vector, inds)
```

`inds` で指定されたインデックスのアイテムを削除し、修正された `a` を返します。後続のアイテムは、結果として生じた隙間を埋めるためにシフトされます。

`inds` は、イテレータまたはソートされていてユニークな整数インデックスのコレクション、または `a` と同じ長さのブールベクターで、`true` が削除するエントリを示します。

# 例

```jldoctest
julia> deleteat!([6, 5, 4, 3, 2, 1], 1:2:5)
3-element Vector{Int64}:
 5
 3
 1

julia> deleteat!([6, 5, 4, 3, 2, 1], [true, false, true, false, true, false])
3-element Vector{Int64}:
 5
 3
 1

julia> deleteat!([6, 5, 4, 3, 2, 1], (2, 2))
ERROR: ArgumentError: indices must be unique and sorted
Stacktrace:
[...]
```
