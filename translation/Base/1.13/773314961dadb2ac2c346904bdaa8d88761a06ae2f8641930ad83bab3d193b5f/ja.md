```julia
setindex(nt::NamedTuple, val, key::Symbol)
```

キーが`key`、値が`val`の新しい`NamedTuple`を構築します。`key`がすでに`nt`のキーに含まれている場合、`val`によって古い値が置き換えられます。

```jldoctest
julia> nt = (a = 3,)
(a = 3,)

julia> Base.setindex(nt, 33, :b)
(a = 3, b = 33)

julia> Base.setindex(nt, 4, :a)
(a = 4,)

julia> Base.setindex(nt, "a", :a)
(a = "a",)
```
