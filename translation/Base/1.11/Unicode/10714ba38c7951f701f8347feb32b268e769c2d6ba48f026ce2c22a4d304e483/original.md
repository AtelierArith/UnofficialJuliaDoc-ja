```
isvalid(T, value) -> Bool
```

Return `true` if the given value is valid for that type. Types currently can be either `AbstractChar` or `String`. Values for `AbstractChar` can be of type `AbstractChar` or [`UInt32`](@ref). Values for `String` can be of that type, `SubString{String}`, `Vector{UInt8}`, or a contiguous subarray thereof.

# Examples

```jldoctest
julia> isvalid(Char, 0xd800)
false

julia> isvalid(String, SubString("thisisvalid",1,5))
true

julia> isvalid(Char, 0xd799)
true
```

!!! compat "Julia 1.6"
    Support for subarray values was added in Julia 1.6.

