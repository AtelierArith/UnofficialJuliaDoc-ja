```julia
prepend!(a::Vector, collections...) -> collection
```

各 `collections` の要素を、`a` の先頭に挿入します。

`collections` で複数のコレクションを指定した場合、順序は維持されます。`collections[1]` の要素が `a` の最も左側に配置され、以降も同様です。

!!! compat "Julia 1.6"
    先頭に追加するコレクションを複数指定するには、Julia 1.6 以降が必要です。


# Examples

```jldoctest
julia> prepend!([3], [1, 2])
3-element Vector{Int64}:
 1
 2
 3

julia> prepend!([6], [1, 2], [3, 4, 5])
6-element Vector{Int64}:
 1
 2
 3
 4
 5
 6
```
