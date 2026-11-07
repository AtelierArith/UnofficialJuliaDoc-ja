```julia
Core.memorynew(::Type{T} where T <: GenericMemory, n::Int)
```

Construct an uninitialized [`GenericMemory`](@ref) of length `n`.

See also [`Memory`](@ref Core.Memory), [`Memory{T}(undef, n)`](@ref Core.Memory(::UndefInitializer, ::Int)).
