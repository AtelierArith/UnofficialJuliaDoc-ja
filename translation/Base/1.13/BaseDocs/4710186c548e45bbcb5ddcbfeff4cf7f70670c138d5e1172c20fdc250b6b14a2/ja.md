```julia
Core.memorynew(::Type{T} where T <: GenericMemory, n::Int)
```

長さが`n`の、未初期化の[`GenericMemory`](@ref)を構築します。

関連項目：[`Memory`](@ref Core.Memory)、[`Memory{T}(undef, n)`](@ref Core.Memory(::UndefInitializer, ::Int))。
