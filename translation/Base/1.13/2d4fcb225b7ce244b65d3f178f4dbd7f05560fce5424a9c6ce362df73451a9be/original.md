```julia
!f::Function
```

Predicate function negation: when the argument of `!` is a function, it returns a composed function which computes the boolean negation of `f`.

See also [`∘`](@ref).

# Examples

```jldoctest
julia> str = "∀ ε > 0, ∃ δ > 0: |x-y| < δ ⇒ |f(x)-f(y)| < ε"
"∀ ε > 0, ∃ δ > 0: |x-y| < δ ⇒ |f(x)-f(y)| < ε"

julia> filter(isletter, str)
"εδxyδfxfyε"

julia> filter(!isletter, str)
"∀  > 0, ∃  > 0: |-| <  ⇒ |()-()| < "
```

!!! compat "Julia 1.9"
    Starting with Julia 1.9, `!f` returns a [`ComposedFunction`](@ref) instead of an anonymous function.

