```julia
issorted(itr, lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward)
```

コレクションがソート済みかどうかを判定します。キーワード引数によって、ソート済みとみなす順序を変更できます。詳しくは[`sort!`](@ref)のドキュメントを参照してください。

# Examples

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
