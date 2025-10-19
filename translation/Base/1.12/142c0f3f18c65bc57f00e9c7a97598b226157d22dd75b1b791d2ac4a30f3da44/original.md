```julia
@atomicreplace a.b.x expected => desired
@atomicreplace :sequentially_consistent a.b.x expected => desired
@atomicreplace :sequentially_consistent :monotonic a.b.x expected => desired
@atomicreplace m[idx] expected => desired
@atomicreplace :sequentially_consistent m[idx] expected => desired
@atomicreplace :sequentially_consistent :monotonic m[idx] expected => desired
```

Perform the conditional replacement expressed by the pair atomically, returning the values `(old, success::Bool)`. Where `success` indicates whether the replacement was completed.

This operation translates to a `replaceproperty!(a.b, :x, expected, desired)` or, in case of reference, to a `replaceindex_atomic!(mem, success_order, fail_order, expected, desired, idx)` call, with both orders defaulting to `:sequentially_consistent`.

See [Per-field atomics](@ref man-atomics) section in the manual for more details.

# Examples

```jldoctest
julia> mutable struct Atomic{T}; @atomic x::T; end

julia> a = Atomic(1)
Atomic{Int64}(1)

julia> @atomicreplace a.x 1 => 2 # replace field x of a with 2 if it was 1, with sequential consistency
(old = 1, success = true)

julia> @atomic a.x # fetch field x of a, with sequential consistency
2

julia> @atomicreplace a.x 1 => 3 # replace field x of a with 2 if it was 1, with sequential consistency
(old = 2, success = false)

julia> xchg = 2 => 0; # replace field x of a with 0 if it was 2, with sequential consistency

julia> @atomicreplace a.x xchg
(old = 2, success = true)

julia> @atomic a.x # fetch field x of a, with sequential consistency
0
```

```jldoctest
julia> mem = AtomicMemory{Int}(undef, 2);

julia> @atomic mem[1] = 1;

julia> @atomicreplace mem[1] 1 => 2 # replace the first value of mem with 2 if it was 1, with sequential consistency
(old = 1, success = true)

julia> @atomic mem[1] # fetch the first value of mem, with sequential consistency
2

julia> @atomicreplace mem[1] 1 => 3 # replace field x of a with 2 if it was 1, with sequential consistency
(old = 2, success = false)

julia> xchg = 2 => 0; # replace field x of a with 0 if it was 2, with sequential consistency

julia> @atomicreplace mem[1] xchg
(old = 2, success = true)

julia> @atomic mem[1] # fetch the first value of mem, with sequential consistency
0
```

!!! compat "Julia 1.7"
    Atomic fields functionality requires at least Julia 1.7.


!!! compat "Julia 1.12"
    Atomic reference functionality requires at least Julia 1.12.

