```julia
setindex(nt::NamedTuple, val, key::Symbol)
```

キー `key` の値を `val` に設定した、新しい `NamedTuple` を構築します。`key` がすでに `nt` のキーに含まれている場合、`val` は以前の値を置き換えます。

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
