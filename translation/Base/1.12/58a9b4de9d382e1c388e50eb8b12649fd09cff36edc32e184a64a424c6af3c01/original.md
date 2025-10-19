```julia
xor(x, y)
⊻(x, y)
```

Bitwise exclusive or of `x` and `y`. Implements [three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic), returning [`missing`](@ref) if one of the arguments is `missing`.

The infix operation `a ⊻ b` is a synonym for `xor(a,b)`, and `⊻` can be typed by tab-completing `\xor` or `\veebar` in the Julia REPL.

# Examples

```jldoctest
julia> xor(true, false)
true

julia> xor(true, true)
false

julia> xor(true, missing)
missing

julia> false ⊻ false
false

julia> [true; true; false] .⊻ [true; false; false]
3-element BitVector:
 0
 1
 0
```
