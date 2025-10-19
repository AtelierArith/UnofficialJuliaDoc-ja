```julia
typemin(T)
```

The lowest value representable by the given (real) numeric DataType `T`.

See also: [`floatmin`](@ref), [`typemax`](@ref), [`eps`](@ref).

# Examples

```jldoctest
julia> typemin(Int8)
-128

julia> typemin(UInt32)
0x00000000

julia> typemin(Float16)
-Inf16

julia> typemin(Float32)
-Inf32

julia> nextfloat(-Inf32)  # smallest finite Float32 floating point number
-3.4028235f38
```
