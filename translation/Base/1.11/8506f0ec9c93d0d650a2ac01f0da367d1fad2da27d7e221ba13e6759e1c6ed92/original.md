```
@atomicswap a.b.x = new
@atomicswap :sequentially_consistent a.b.x = new
```

Stores `new` into `a.b.x` and returns the old value of `a.b.x`.

This operation translates to a `swapproperty!(a.b, :x, new)` call.

See [Per-field atomics](@ref man-atomics) section in the manual for more details.

# Examples

```jldoctest
julia> mutable struct Atomic{T}; @atomic x::T; end

julia> a = Atomic(1)
Atomic{Int64}(1)

julia> @atomicswap a.x = 2+2 # replace field x of a with 4, with sequential consistency
1

julia> @atomic a.x # fetch field x of a, with sequential consistency
4
```

!!! compat "Julia 1.7"
    This functionality requires at least Julia 1.7.

