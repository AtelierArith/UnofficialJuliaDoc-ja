```julia
SecretBuffer(str::AbstractString)
```

A convenience constructor to initialize a `SecretBuffer` from a non-secret string.

Strings are bad at keeping secrets because they are unable to be securely zeroed or destroyed. Therefore, avoid using this constructor with secret data. Instead of starting with a string, either construct the `SecretBuffer` incrementally with `SecretBuffer()` and [`write`](@ref), or use a `Vector{UInt8}` with the `Base.SecretBuffer!(::AbstractVector{UInt8})` constructor.
