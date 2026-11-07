```julia
exponent_max(T)
```

Maximum [`exponent`](@ref) value for a floating point number of type `T`.

# Examples

```jldoctest
julia> Base.exponent_max(Float64)
1023
```

Note, `exponent_max(T) + 1` is a possible value of the exponent field with bias, which might be used as sentinel value for `Inf` or `NaN`.
