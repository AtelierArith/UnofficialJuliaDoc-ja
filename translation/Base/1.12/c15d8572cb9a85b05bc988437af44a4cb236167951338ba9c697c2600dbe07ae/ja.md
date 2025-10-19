```julia
filter!(f, a)
```

コレクション `a` を更新し、`f` が `false` の要素を削除します。関数 `f` には1つの引数が渡されます。

# 例

```jldoctest
julia> filter!(isodd, Vector(1:10))
5-element Vector{Int64}:
 1
 3
 5
 7
 9
```
