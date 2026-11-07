```julia
!(x)
```

Boolean not. Implements [three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic), returning [`missing`](@ref) if `x` is `missing`.

See also [`~`](@ref) for bitwise not.

# Examples

```jldoctest
julia> !true
false

julia> !false
true

julia> !missing
missing

julia> .![true false true]
1×3 BitMatrix:
 0  1  0
```
