```julia
//(num, den)
```

Divide two integers or rational numbers, giving a [`Rational`](@ref) result. More generally, `//` can be used for exact rational division of other numeric types with integer or rational components, such as complex numbers with integer components.

Note that floating-point ([`AbstractFloat`](@ref)) arguments are not permitted by `//` (even if the values are rational). The arguments must be subtypes of [`Integer`](@ref), `Rational`, or composites thereof.

# Examples

```jldoctest
julia> 3 // 5
3//5

julia> (3 // 5) // (2 // 1)
3//10

julia> (1+2im) // (3+4im)
11//25 + 2//25*im

julia> 1.0 // 2
ERROR: MethodError: no method matching //(::Float64, ::Int64)
[...]
```
