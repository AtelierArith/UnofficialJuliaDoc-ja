```julia
deleteat!(a::Vector, inds)
```

`inds`で指定されたインデックスの要素を削除し、変更後の`a`を返します。後続の要素は、空いた位置を埋めるように移動します。

`inds`には、ソート済みで重複のない整数インデックスのイテレーターまたはコレクションを指定できます。または、`a`と同じ長さのブールベクトルを指定し、`true`で削除する要素を示すこともできます。

# Examples

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
