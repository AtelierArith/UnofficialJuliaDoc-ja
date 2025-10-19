```julia
float(T::Type)
```

Return an appropriate type to represent a value of type `T` as a floating point value. Equivalent to `typeof(float(zero(T)))`.

# Examples

```jldoctest
julia> float(Complex{Int})
ComplexF64 (alias for Complex{Float64})

julia> float(Int)
Float64
```
