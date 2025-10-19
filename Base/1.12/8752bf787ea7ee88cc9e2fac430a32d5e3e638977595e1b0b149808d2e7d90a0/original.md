```julia
typemax(T)
```

The highest value representable by the given (real) numeric `DataType`.

See also: [`floatmax`](@ref), [`typemin`](@ref), [`eps`](@ref).

# Examples

```jldoctest
julia> typemax(Int8)
127

julia> typemax(UInt32)
0xffffffff

julia> typemax(Float64)
Inf

julia> typemax(Float32)
Inf32

julia> floatmax(Float32)  # largest finite Float32 floating point number
3.4028235f38
```
