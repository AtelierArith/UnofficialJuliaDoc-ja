```julia
Base.isambiguous(m1, m2; ambiguous_bottom=false) -> Bool
```

Determine whether two methods `m1` and `m2` may be ambiguous for some call signature. This test is performed in the context of other methods of the same function; in isolation, `m1` and `m2` might be ambiguous, but if a third method resolving the ambiguity has been defined, this returns `false`. Alternatively, in isolation `m1` and `m2` might be ordered, but if a third method cannot be sorted with them, they may cause an ambiguity together.

For parametric types, the `ambiguous_bottom` keyword argument controls whether `Union{}` counts as an ambiguous intersection of type parameters – when `true`, it is considered ambiguous, when `false` it is not.

# Examples

```jldoctest
julia> foo(x::Complex{<:Integer}) = 1
foo (generic function with 1 method)

julia> foo(x::Complex{<:Rational}) = 2
foo (generic function with 2 methods)

julia> m1, m2 = collect(methods(foo));

julia> typeintersect(m1.sig, m2.sig)
Tuple{typeof(foo), Complex{Union{}}}

julia> Base.isambiguous(m1, m2, ambiguous_bottom=true)
true

julia> Base.isambiguous(m1, m2, ambiguous_bottom=false)
false
```
