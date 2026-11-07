```julia
muladd(x, y, z)
```

Combined multiply-add: computes `x*y+z`, but allowing the add and multiply to be merged with each other or with surrounding operations for performance. For example, this may be implemented as an [`fma`](@ref) if the hardware supports it efficiently. The result can be different on different machines and can also be different on the same machine due to constant propagation or other optimizations. See [`fma`](@ref).

# Examples

```jldoctest
julia> muladd(3, 2, 1)
7

julia> 3 * 2 + 1
7
```
