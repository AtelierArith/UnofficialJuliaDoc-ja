```julia
uint_map(x, order::Base.Order.Ordering)::Unsigned
```

Map `x` to an un unsigned integer, maintaining sort order.

The map should be reversible with [`uint_unmap`](@ref), so `isless(order, a, b)` must be a linear ordering for `a, b <: typeof(x)`. Satisfies `isless(order, a, b) === (uint_map(a, order) < uint_map(b, order))` and `x === uint_unmap(typeof(x), uint_map(x, order), order)`

See also: [`UIntMappable`](@ref) [`uint_unmap`](@ref)
