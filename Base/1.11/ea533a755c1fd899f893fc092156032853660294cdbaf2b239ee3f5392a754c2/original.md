```
floatmax(T = Float64)
```

Return the largest finite number representable by the floating-point type `T`.

See also: [`typemax`](@ref), [`floatmin`](@ref), [`eps`](@ref).

# Examples

```jldoctest
julia> floatmax(Float16)
Float16(6.55e4)

julia> floatmax(Float32)
3.4028235f38

julia> floatmax()
1.7976931348623157e308

julia> typemax(Float64)
Inf
```
