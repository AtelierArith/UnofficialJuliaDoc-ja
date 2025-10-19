```julia
isassigned(ref::RefValue) -> Bool
```

Test whether the given [`Ref`](@ref) is associated with a value. This is always true for a [`Ref`](@ref) of a bitstype object. Return `false` if the reference is undefined.

# Examples

```jldoctest
julia> ref = Ref{Function}()
Base.RefValue{Function}(#undef)

julia> isassigned(ref)
false

julia> ref[] = (foobar(x) = x)
foobar (generic function with 1 method)

julia> isassigned(ref)
true

julia> isassigned(Ref{Int}())
true
```
