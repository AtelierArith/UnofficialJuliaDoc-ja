```julia
PipeBuffer(data::AbstractVector{UInt8}=UInt8[]; maxsize::Integer = typemax(Int))
```

An [`IOBuffer`](@ref) that allows reading and performs writes by appending. Seeking and truncating are not supported. See [`IOBuffer`](@ref) for the available constructors. If `data` is given, creates a `PipeBuffer` to operate on a data vector, optionally specifying a size beyond which the underlying `Array` may not be grown.
