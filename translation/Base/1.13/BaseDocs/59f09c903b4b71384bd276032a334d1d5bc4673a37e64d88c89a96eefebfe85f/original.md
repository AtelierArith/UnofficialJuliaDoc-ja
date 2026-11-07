```julia
Unsigned <: Integer
```

Abstract supertype for all unsigned integers.

Built-in unsigned integers are printed in hexadecimal, with prefix `0x`, and can be entered in the same way.

# Examples

```julia
julia> typemax(UInt8)
0xff

julia> Int(0x00d)
13

julia> unsigned(true)
0x0000000000000001
```
