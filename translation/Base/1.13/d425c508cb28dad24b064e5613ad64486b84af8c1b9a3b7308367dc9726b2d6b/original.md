```julia
bswap(n)
```

Reverse the byte order of `n`.

(See also [`ntoh`](@ref) and [`hton`](@ref) to convert between the current native byte order and big-endian order.)

# Examples

```jldoctest
julia> a = bswap(0x10203040)
0x40302010

julia> bswap(a)
0x10203040

julia> string(1, base = 2)
"1"

julia> string(bswap(1), base = 2)
"100000000000000000000000000000000000000000000000000000000"
```
