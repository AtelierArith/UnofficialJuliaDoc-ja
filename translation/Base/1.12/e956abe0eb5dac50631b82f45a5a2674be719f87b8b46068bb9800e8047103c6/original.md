```julia
string(n::Integer; base::Integer = 10, pad::Integer = 1)
```

Convert an integer `n` to a string in the given `base`, optionally specifying a number of digits to pad to.

See also [`digits`](@ref), [`bitstring`](@ref), [`count_zeros`](@ref).

# Examples

```jldoctest
julia> string(5, base = 13, pad = 4)
"0005"

julia> string(-13, base = 5, pad = 4)
"-0023"
```
