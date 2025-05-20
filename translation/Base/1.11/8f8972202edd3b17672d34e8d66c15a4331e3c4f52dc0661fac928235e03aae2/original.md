```
bitstring(n)
```

A string giving the literal bit representation of a primitive type.

See also [`count_ones`](@ref), [`count_zeros`](@ref), [`digits`](@ref).

# Examples

```jldoctest
julia> bitstring(Int32(4))
"00000000000000000000000000000100"

julia> bitstring(2.2)
"0100000000000001100110011001100110011001100110011001100110011010"
```
