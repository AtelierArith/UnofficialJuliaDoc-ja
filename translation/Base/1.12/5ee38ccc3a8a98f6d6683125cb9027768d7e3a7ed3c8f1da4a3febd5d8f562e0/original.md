```julia
objectid(x) -> UInt
```

Get a hash value for `x` based on object identity.

If `x === y` then `objectid(x) == objectid(y)`, and usually when `x !== y`, `objectid(x) != objectid(y)`.

See also [`hash`](@ref), [`IdDict`](@ref).
