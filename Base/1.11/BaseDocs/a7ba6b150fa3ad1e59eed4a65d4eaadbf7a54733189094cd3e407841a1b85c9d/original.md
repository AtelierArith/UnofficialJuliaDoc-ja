```
x && y
```

Short-circuiting boolean AND.

See also [`&`](@ref), the ternary operator `? :`, and the manual section on [control flow](@ref man-conditional-evaluation).

# Examples

```jldoctest
julia> x = 3;

julia> x > 1 && x < 10 && x isa Int
true

julia> x < 0 && error("expected positive x")
false
```
