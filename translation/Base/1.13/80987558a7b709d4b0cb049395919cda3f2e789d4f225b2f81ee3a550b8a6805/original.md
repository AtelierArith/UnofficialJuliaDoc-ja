```julia
real(T::Type)
```

Return the type that represents the real part of a value of type `T`. e.g: for `T == Complex{R}`, returns `R`. Equivalent to `typeof(real(zero(T)))`.

# Examples

```jldoctest
julia> real(Complex{Int})
Int64

julia> real(Float64)
Float64
```
