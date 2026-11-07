```julia
typemin(T)
```

The lowest value representable by the given (real) numeric DataType `T`.

See also: [`floatmin`](@ref), [`maxintfloat`](@ref), [`typemax`](@ref), [`eps`](@ref).

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

julia> floatmin(Float32)  # smallest positive finite Float32 floating point number
1.1754944f-38

julia> nextfloat(-Inf32) == -floatmax(Float32)  # equivalent ways of getting the lowest finite Float32 floating point number
true
```
