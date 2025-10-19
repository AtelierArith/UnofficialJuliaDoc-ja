```julia
@atomic var
@atomic order ex
```

Mark `var` or `ex` as being performed atomically, if `ex` is a supported expression. If no `order` is specified it defaults to :sequentially_consistent.

```julia
@atomic a.b.x = new
@atomic a.b.x += addend
@atomic :release a.b.x = new
@atomic :acquire_release a.b.x += addend
@atomic m[idx] = new
@atomic m[idx] += addend
@atomic :release m[idx] = new
@atomic :acquire_release m[idx] += addend
```

Perform the store operation expressed on the right atomically and return the new value.

With assignment (`=`), this operation translates to a `setproperty!(a.b, :x, new)` or, in case of reference, to a `setindex_atomic!(m, order, new, idx)` call, with `order` defaulting to `:sequentially_consistent`.

With any modifying operator this operation translates to a `modifyproperty!(a.b, :x, op, addend)[2]` or, in case of reference, to a `modifyindex_atomic!(m, order, op, addend, idx...)[2]` call, with `order` defaulting to `:sequentially_consistent`.

```julia
@atomic a.b.x max arg2
@atomic a.b.x + arg2
@atomic max(a.b.x, arg2)
@atomic :acquire_release max(a.b.x, arg2)
@atomic :acquire_release a.b.x + arg2
@atomic :acquire_release a.b.x max arg2
@atomic m[idx] max arg2
@atomic m[idx] + arg2
@atomic max(m[idx], arg2)
@atomic :acquire_release max(m[idx], arg2)
@atomic :acquire_release m[idx] + arg2
@atomic :acquire_release m[idx] max arg2
```

Perform the binary operation expressed on the right atomically. Store the result into the field or the reference in the first argument, and return the values `(old, new)`.

This operation translates to a `modifyproperty!(a.b, :x, func, arg2)` or, in case of reference to a `modifyindex_atomic!(m, order, func, arg2, idx)` call, with `order` defaulting to `:sequentially_consistent`.

See [Per-field atomics](@ref man-atomics) section in the manual for more details.

# Examples

```jldoctest
julia> mutable struct Atomic{T}; @atomic x::T; end

julia> a = Atomic(1)
Atomic{Int64}(1)

julia> @atomic a.x # fetch field x of a, with sequential consistency
1

julia> @atomic :sequentially_consistent a.x = 2 # set field x of a, with sequential consistency
2

julia> @atomic a.x += 1 # increment field x of a, with sequential consistency
3

julia> @atomic a.x + 1 # increment field x of a, with sequential consistency
3 => 4

julia> @atomic a.x # fetch field x of a, with sequential consistency
4

julia> @atomic max(a.x, 10) # change field x of a to the max value, with sequential consistency
4 => 10

julia> @atomic a.x max 5 # again change field x of a to the max value, with sequential consistency
10 => 10
```

```jldoctest
julia> mem = AtomicMemory{Int}(undef, 2);

julia> @atomic mem[1] = 2 # set mem[1] to value 2 with sequential consistency
2

julia> @atomic :monotonic mem[1] # fetch the first value of mem, with monotonic consistency
2

julia> @atomic mem[1] += 1 # increment the first value of mem, with sequential consistency
3

julia> @atomic mem[1] + 1 # increment the first value of mem, with sequential consistency
3 => 4

julia> @atomic mem[1] # fetch the first value of mem, with sequential consistency
4

julia> @atomic max(mem[1], 10) # change the first value of mem to the max value, with sequential consistency
4 => 10

julia> @atomic mem[1] max 5 # again change the first value of mem to the max value, with sequential consistency
10 => 10
```

!!! compat "Julia 1.7"
    Atomic fields functionality requires at least Julia 1.7.


!!! compat "Julia 1.12"
    Atomic reference functionality requires at least Julia 1.12.

