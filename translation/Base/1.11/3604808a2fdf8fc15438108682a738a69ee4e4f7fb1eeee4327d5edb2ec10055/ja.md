```
pushfirst!(collection, items...) -> collection
```

コレクションの先頭に1つ以上の`items`を挿入します。

この関数は多くの他のプログラミング言語では`unshift`と呼ばれています。

# 例

```jldoctest
julia> pushfirst!([1, 2, 3, 4], 5, 6)
6-element Vector{Int64}:
 5
 6
 1
 2
 3
 4
```
