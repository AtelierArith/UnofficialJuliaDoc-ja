```julia
setindex(nt::NamedTuple, val, key::Symbol)
```

Constructs a new `NamedTuple` with the key `key` set to `val`. If `key` is already in the keys of `nt`, `val` replaces the old value.

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
