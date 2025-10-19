```julia
Core.Intrinsics.atomic_pointermodify(pointer::Ptr{T}, function::(old::T,arg::S)->T, arg::S, order::Symbol) --> old
```

!!! compat "Julia 1.7"
    この関数はJulia 1.7以降が必要です。


See [`unsafe_modify!`](@ref Base.unsafe_modify!).
