```julia
isbitstype(T)
```

Return `true` if type `T` is a "plain data" type, meaning it is immutable and contains no references to other values, only `primitive` types and other `isbitstype` types. Typical examples are numeric types such as [`UInt8`](@ref), [`Float64`](@ref), and [`Complex{Float64}`](@ref). This category of types is significant since they are valid as type parameters, may not track [`isdefined`](@ref) / [`isassigned`](@ref) status, and have a defined layout that is compatible with C. If `T` is not a type, then return `false`.

See also [`isbits`](@ref), [`isprimitivetype`](@ref), [`ismutable`](@ref).

# Examples

```jldoctest
julia> isbitstype(Complex{Float64})
true

julia> isbitstype(Complex)
false
```
