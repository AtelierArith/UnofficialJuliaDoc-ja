```
⊈(a, b) -> Bool
⊉(b, a) -> Bool
```

Negation of `⊆` and `⊇`, i.e. checks that `a` is not a subset of `b`.

See also [`issubset`](@ref) (`⊆`), [`⊊`](@ref).

# Examples

```jldoctest
julia> (1, 2) ⊈ (2, 3)
true

julia> (1, 2) ⊈ (1, 2, 3)
false
```
