```
unsigned(x)
```

Convert a number to an unsigned integer. If the argument is signed, it is reinterpreted as unsigned without checking for negative values.

See also: [`signed`](@ref), [`sign`](@ref), [`signbit`](@ref).

# Examples

```jldoctest
julia> unsigned(-2)
0xfffffffffffffffe

julia> unsigned(Int8(2))
0x02

julia> typeof(ans)
UInt8

julia> signed(unsigned(-2))
-2
```
