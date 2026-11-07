```julia
pushfirst!(collection, items...) -> collection
```

`collection`の先頭に、1つ以上の`items`を挿入します。

この関数は、ほかの多くのプログラミング言語では`unshift`と呼ばれます。

# Examples

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
