```julia
uint_unmap(T::Type, u::Unsigned, order::Base.Order.Ordering)
```

Reconstruct the unique value `x::T` that uint*maps to `u`. Satisfies `x === uint*unmap(T, uint_map(x::T, order), order)`for all`x <: T`.

See also: [`uint_map`](@ref) [`UIntMappable`](@ref)
