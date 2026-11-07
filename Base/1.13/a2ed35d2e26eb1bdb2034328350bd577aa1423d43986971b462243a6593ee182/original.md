```julia
x & y
```

Bitwise and. Implements [three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic), returning [`missing`](@ref) if one operand is `missing` and the other is `true`. Add parentheses for function application form: `(&)(x, y)`.

See also: [`|`](@ref), [`xor`](@ref), [`&&`](@ref).

# Examples

```jldoctest
julia> 4 & 10
0

julia> 4 & 12
4

julia> true & missing
missing

julia> false & missing
false
```
