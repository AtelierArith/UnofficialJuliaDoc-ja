```
BitVector(nt::Tuple{Vararg{Bool}})
```

Construct a `BitVector` from a tuple of `Bool`.

# Examples

```julia-repl
julia> nt = (true, false, true, false)
(true, false, true, false)

julia> BitVector(nt)
4-element BitVector:
 1
 0
 1
 0
```
