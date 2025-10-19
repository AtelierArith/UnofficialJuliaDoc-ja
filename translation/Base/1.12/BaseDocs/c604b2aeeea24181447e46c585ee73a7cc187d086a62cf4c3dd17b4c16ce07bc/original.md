```julia
Core.Intrinsics.atomic_pointerswap(pointer::Ptr{T}, new::T, order::Symbol) --> old
```

!!! compat "Julia 1.7"
    This function requires Julia 1.7 or later.


See [`unsafe_swap!`](@ref Base.unsafe_swap!).
