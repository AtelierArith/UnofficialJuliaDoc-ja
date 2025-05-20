```
inplace_adj_or_trans(::AbstractArray) -> adjoint!|transpose!|copyto!
inplace_adj_or_trans(::Type{<:AbstractArray}) -> adjoint!|transpose!|copyto!
```

Return [`adjoint!`](@ref) from an `Adjoint` type or object and [`transpose!`](@ref) from a `Transpose` type or object. Otherwise, return [`copyto!`](@ref). Note that `Adjoint` and `Transpose` have to be the outer-most wrapper object for a non-`identity` function to be returned.
