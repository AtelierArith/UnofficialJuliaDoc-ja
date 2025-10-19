```julia
issorted(v, lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward)
```

コレクションがソートされた順序にあるかどうかをテストします。キーワードは、[`sort!`](@ref) ドキュメントに記載されているように、どの順序がソートされたと見なされるかを変更します。

# 例

```jldoctest
julia> issorted([1, 2, 3])
true

julia> issorted([(1, "b"), (2, "a")], by = x -> x[1])
true

julia> issorted([(1, "b"), (2, "a")], by = x -> x[2])
false

julia> issorted([(1, "b"), (2, "a")], by = x -> x[2], rev=true)
true

julia> issorted([1, 2, -2, 3], by=abs)
true
```
