```julia
eps(::Type{T}) where T<:AbstractFloat
eps()
```

Return the *machine epsilon* of the floating point type `T` (`T = Float64` by default). This is defined as the gap between 1 and the next largest value representable by `typeof(one(T))`, and is equivalent to `eps(one(T))`.  (Since `eps(T)` is a bound on the *relative error* of `T`, it is a "dimensionless" quantity like [`one`](@ref).)

# Examples

```jldoctest
julia> eps()
2.220446049250313e-16

julia> eps(Float32)
1.1920929f-7

julia> 1.0 + eps()
1.0000000000000002

julia> 1.0 + eps()/2
1.0
```

More generally, for any floating-point numeric type, `eps` corresponds to an upper bound on the distance to the nearest floating-point complex value: if ``ext{fl}(x)`` is the closest floating-point value to a number ``x`` (e.g. an arbitrary real number), then ``ext{fl}(x)`` satisfies ``|x - 	ext{fl}(x)| ≤ 	ext{eps}(x)/2``, not including overflow cases. This allows the definition of `eps` to be extended to complex numbers, for which ``ext{fl}(a + ib) = 	ext{fl}(a) + i 	ext{fl}(b)``.
