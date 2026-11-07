```julia
Core.Intrinsics.atomic_pointermodify(pointer::Ptr{T}, function::(old::T,arg::S)->T, arg::S, order::Symbol) --> old
```

!!! compat "Julia 1.7"
    この関数を使用するには、Julia 1.7 以降が必要です。


[`unsafe_modify!`](@ref Base.unsafe_modify!)
