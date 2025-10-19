```julia
@atomicswap a.b.x = new
@atomicswap :sequentially_consistent a.b.x = new
@atomicswap m[idx] = new
@atomicswap :sequentially_consistent m[idx] = new
```

Stores `new` into `a.b.x` (`m[idx]` in case of reference) and returns the old value of `a.b.x` (the old value stored at `m[idx]`, respectively).

This operation translates to a `swapproperty!(a.b, :x, new)` or, in case of reference, `swapindex_atomic!(mem, order, new, idx)` call, with `order` defaulting to `:sequentially_consistent`.

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

```jldoctest
julia> mem = AtomicMemory{Int}(undef, 2);

julia> @atomic mem[1] = 1;

julia> @atomicswap mem[1] = 4 # replace the first value of `mem` with 4, with sequential consistency
1

julia> @atomic mem[1] # fetch the first value of mem, with sequential consistency
4
```

!!! compat "Julia 1.7"
    Atomic fields functionality requires at least Julia 1.7.


!!! compat "Julia 1.12"
    Atomic reference functionality requires at least Julia 1.12.

