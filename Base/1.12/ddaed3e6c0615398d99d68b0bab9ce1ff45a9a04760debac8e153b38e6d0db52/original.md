```julia
x | y
```

Bitwise or. Implements [three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic), returning [`missing`](@ref) if one operand is `missing` and the other is `false`.

See also: [`&`](@ref), [`xor`](@ref), [`||`](@ref).

# Examples

```jldoctest
julia> 4 | 10
14

julia> 4 | 1
5

julia> true | missing
true

julia> false | missing
missing
```
