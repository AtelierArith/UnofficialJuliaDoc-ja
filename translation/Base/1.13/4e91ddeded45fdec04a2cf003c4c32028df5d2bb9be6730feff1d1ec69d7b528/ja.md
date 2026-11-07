```julia
filter!(f, a)
```

`a` コレクションを更新し、`f` が `false` である要素を削除します。この関数 `f` には、引数を1つ渡します。

# Examples

```jldoctest
julia> filter!(isodd, Vector(1:10))
5-element Vector{Int64}:
 1
 3
 5
 7
 9
```
