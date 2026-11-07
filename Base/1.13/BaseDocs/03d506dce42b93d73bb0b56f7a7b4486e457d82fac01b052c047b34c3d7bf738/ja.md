```julia
Core.Intrinsics.atomic_pointerreplace(pointer::Ptr{T}, expected::Any, new::T, success_order::Symbol, failure_order::Symbol) --> (old, cmp)
```

!!! compat "Julia 1.7"
    この関数を使用するには、Julia 1.7 以降が必要です。


[`unsafe_replace!`](@ref Base.unsafe_replace!)。
