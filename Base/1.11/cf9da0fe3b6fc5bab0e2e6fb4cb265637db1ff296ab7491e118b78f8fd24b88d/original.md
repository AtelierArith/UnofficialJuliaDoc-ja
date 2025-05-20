```
big(T::Type)
```

Compute the type that represents the numeric type `T` with arbitrary precision. Equivalent to `typeof(big(zero(T)))`.

# Examples

```jldoctest
julia> big(Rational)
Rational{BigInt}

julia> big(Float64)
BigFloat

julia> big(Complex{Int})
Complex{BigInt}
```
