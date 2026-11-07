```julia
delete(a::NamedTuple, field::Symbol)
```

Construct a new named tuple from `a` by removing the named field.

```jldoctest
julia> Base.delete((a=1, b=2, c=3), :a)
(b = 2, c = 3)

julia> Base.delete((a=1, b=2, c=3), :b)
(a = 1, c = 3)
```
