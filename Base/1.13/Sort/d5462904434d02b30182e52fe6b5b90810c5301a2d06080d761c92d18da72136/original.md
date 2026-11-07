```julia
UIntMappable(T::Type, order::Base.Order.Ordering)
```

Return `typeof(uint_map(x::T, order))` if [`uint_map`](@ref) and [`uint_unmap`](@ref) are implemented.

If either is not implemented, return `nothing`.
