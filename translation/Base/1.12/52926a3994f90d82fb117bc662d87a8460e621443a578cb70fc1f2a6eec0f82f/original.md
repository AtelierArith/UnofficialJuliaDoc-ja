```julia
⊊(a, b) -> Bool
⊋(b, a) -> Bool
```

Determines if `a` is a subset of, but not equal to, `b`.

See also [`issubset`](@ref) (`⊆`), [`⊈`](@ref).

# Examples

```jldoctest
julia> (1, 2) ⊊ (1, 2, 3)
true

julia> (1, 2) ⊊ (1, 2)
false
```
