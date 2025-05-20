```
nor(x, y)
⊽(x, y)
```

Bitwise nor (not or) of `x` and `y`. Implements [three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic), returning [`missing`](@ref) if one of the arguments is `missing` and the other is not `true`.

The infix operation `a ⊽ b` is a synonym for `nor(a,b)`, and `⊽` can be typed by tab-completing `\nor` or `\barvee` in the Julia REPL.

# Examples

```jldoctest
julia> nor(true, false)
false

julia> nor(true, true)
false

julia> nor(true, missing)
false

julia> false ⊽ false
true

julia> false ⊽ missing
missing

julia> [true; true; false] .⊽ [true; false; false]
3-element BitVector:
 0
 0
 1
```
