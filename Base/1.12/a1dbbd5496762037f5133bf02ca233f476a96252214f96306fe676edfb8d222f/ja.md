```julia
prepend!(a::Vector, collections...) -> collection
```

各 `collections` の要素を `a` の先頭に挿入します。

`collections` が複数のコレクションを指定する場合、順序は維持されます： `collections[1]` の要素が `a` の最も左に表示され、その後に続きます。

!!! compat "Julia 1.6"
    複数のコレクションを先頭に追加するには、少なくとも Julia 1.6 が必要です。


# 例

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
