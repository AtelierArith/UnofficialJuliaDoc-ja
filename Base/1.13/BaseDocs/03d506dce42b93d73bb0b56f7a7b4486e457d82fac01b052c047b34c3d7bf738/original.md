```julia
Core.Intrinsics.atomic_pointerreplace(pointer::Ptr{T}, expected::Any, new::T, success_order::Symbol, failure_order::Symbol) --> (old, cmp)
```

!!! compat "Julia 1.7"
    This function requires Julia 1.7 or later.


See [`unsafe_replace!`](@ref Base.unsafe_replace!).
