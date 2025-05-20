```
typejoin(T, S, ...)
```

Return the closest common ancestor of types `T` and `S`, i.e. the narrowest type from which they both inherit. Recurses on additional varargs.

# Examples

```jldoctest
julia> typejoin(Int, Float64)
Real

julia> typejoin(Int, Float64, ComplexF32)
Number
```
