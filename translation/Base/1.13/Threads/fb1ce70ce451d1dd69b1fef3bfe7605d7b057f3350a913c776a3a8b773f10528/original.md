```julia
Threads.atomic_xchg!(x::Atomic{T}, newval::T) where T
```

Atomically exchange the value in `x`

Atomically exchanges the value in `x` with `newval`. Returns the **old** value.

For further details, see LLVM's `atomicrmw xchg` instruction.

# Examples

```jldoctest
julia> x = Threads.Atomic{Int}(3)
Base.Threads.Atomic{Int64}(3)

julia> Threads.atomic_xchg!(x, 2)
3

julia> x[]
2
```
