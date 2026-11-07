```julia
Core.memorynew(::Type{T} where T <: GenericMemory, n::Int)
```

長さが`n`の未初期化の[`GenericMemory`](@ref)を構築します。

[`Memory`](@ref Core.Memory)、[`Memory{T}(undef, n)`](@ref Core.Memory(::UndefInitializer, ::Int))も参照してください。
