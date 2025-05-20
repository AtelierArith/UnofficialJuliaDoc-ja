```
bitrotate(x::Base.BitInteger, k::Integer)
```

`bitrotate(x, k)` implements bitwise rotation. It returns the value of `x` with its bits rotated left `k` times. A negative value of `k` will rotate to the right instead.

!!! compat "Julia 1.5"
    This function requires Julia 1.5 or later.


See also: [`<<`](@ref), [`circshift`](@ref), [`BitArray`](@ref).

```jldoctest
julia> bitrotate(UInt8(114), 2)
0xc9

julia> bitstring(bitrotate(0b01110010, 2))
"11001001"

julia> bitstring(bitrotate(0b01110010, -2))
"10011100"

julia> bitstring(bitrotate(0b01110010, 8))
"01110010"
```
