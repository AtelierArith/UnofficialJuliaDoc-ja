```julia
isimmutable(v) -> Bool
```

!!! warning
    Consider using `!ismutable(v)` instead, as `isimmutable(v)` will be replaced by `!ismutable(v)` in a future release. (Since Julia 1.5)


Return `true` iff value `v` is immutable.  See [Mutable Composite Types](@ref) for a discussion of immutability. Note that this function works on values, so if you give it a type, it will tell you that a value of `DataType` is mutable.

# Examples

```jldoctest
julia> isimmutable(1)
true

julia> isimmutable([1,2])
false
```
