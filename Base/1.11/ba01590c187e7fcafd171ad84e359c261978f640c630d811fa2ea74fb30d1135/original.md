```
fld1(x, y)
```

Flooring division, returning a value consistent with `mod1(x,y)`

See also [`mod1`](@ref), [`fldmod1`](@ref).

# Examples

```jldoctest
julia> x = 15; y = 4;

julia> fld1(x, y)
4

julia> x == fld(x, y) * y + mod(x, y)
true

julia> x == (fld1(x, y) - 1) * y + mod1(x, y)
true
```
