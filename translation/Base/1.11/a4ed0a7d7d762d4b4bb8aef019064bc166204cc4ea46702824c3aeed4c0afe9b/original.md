```
@atomiconce a.b.x = value
@atomiconce :sequentially_consistent a.b.x = value
@atomiconce :sequentially_consistent :monotonic a.b.x = value
```

Perform the conditional assignment of value atomically if it was previously unset, returning the value `success::Bool`. Where `success` indicates whether the assignment was completed.

This operation translates to a `setpropertyonce!(a.b, :x, value)` call.

See [Per-field atomics](@ref man-atomics) section in the manual for more details.

# Examples

```jldoctest
julia> mutable struct AtomicOnce
           @atomic x
           AtomicOnce() = new()
       end

julia> a = AtomicOnce()
AtomicOnce(#undef)

julia> @atomiconce a.x = 1 # set field x of a to 1, if unset, with sequential consistency
true

julia> @atomic a.x # fetch field x of a, with sequential consistency
1

julia> @atomiconce a.x = 1 # set field x of a to 1, if unset, with sequential consistency
false
```

!!! compat "Julia 1.11"
    This functionality requires at least Julia 1.11.

