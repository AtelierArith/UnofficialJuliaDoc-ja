```julia
@atomiconce a.b.x = value
@atomiconce :sequentially_consistent a.b.x = value
@atomiconce :sequentially_consistent :monotonic a.b.x = value
@atomiconce m[idx] = value
@atomiconce :sequentially_consistent m[idx] = value
@atomiconce :sequentially_consistent :monotonic m[idx] = value
```

Perform the conditional assignment of value atomically if it was previously unset. Returned value `success::Bool` indicates whether the assignment was completed.

This operation translates to a `setpropertyonce!(a.b, :x, value)` or, in case of reference, to a `setindexonce_atomic!(m, success_order, fail_order, value, idx)` call, with both orders defaulting to `:sequentially_consistent`.

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

julia> @atomiconce :monotonic a.x = 2 # set field x of a to 1, if unset, with monotonic consistence
false
```

```jldoctest
julia> mem = AtomicMemory{Vector{Int}}(undef, 1);

julia> isassigned(mem, 1)
false

julia> @atomiconce mem[1] = [1] # set the first value of mem to [1], if unset, with sequential consistency
true

julia> isassigned(mem, 1)
true

julia> @atomic mem[1] # fetch the first value of mem, with sequential consistency
1-element Vector{Int64}:
 1

julia> @atomiconce :monotonic mem[1] = [2] # set the first value of mem to [2], if unset, with monotonic
false

julia> @atomic mem[1]
1-element Vector{Int64}:
 1
```

!!! compat "Julia 1.11"
    Atomic fields functionality requires at least Julia 1.11.


!!! compat "Julia 1.12"
    Atomic reference functionality requires at least Julia 1.12.

