```
bitreverse(x)
```

Reverse the order of bits in integer `x`. `x` must have a fixed bit width, e.g. be an `Int16` or `Int32`.

!!! compat "Julia 1.5"
    This function requires Julia 1.5 or later.


# Examples

```jldoctest
julia> bitreverse(0x8080808080808080)
0x0101010101010101

julia> reverse(bitstring(0xa06e)) == bitstring(bitreverse(0xa06e))
true
```
