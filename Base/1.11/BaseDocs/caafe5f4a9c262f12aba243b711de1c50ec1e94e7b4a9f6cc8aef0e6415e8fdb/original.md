```
Core.Intrinsics.atomic_pointermodify(pointer::Ptr{T}, function::(old::T,arg::S)->T, arg::S, order::Symbol) --> old
```

!!! compat "Julia 1.7"
    This function requires Julia 1.7 or later.


See [`unsafe_modify!`](@ref Base.unsafe_modify!).
