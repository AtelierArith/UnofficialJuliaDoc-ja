```julia
prevfloat(x::AbstractFloat)
```

Return the largest floating point number `y` of the same type as `x` such that `y < x`. If no such `y` exists (e.g. if `x` is `-Inf` or `NaN`), then return `x`.
