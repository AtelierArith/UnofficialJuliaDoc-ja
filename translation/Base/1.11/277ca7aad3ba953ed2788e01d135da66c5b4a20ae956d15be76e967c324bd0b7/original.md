```
float(x)
```

Convert a number or array to a floating point data type.

See also: [`complex`](@ref), [`oftype`](@ref), [`convert`](@ref).

# Examples

```jldoctest
julia> float(1:1000)
1.0:1.0:1000.0

julia> float(typemax(Int32))
2.147483647e9
```
