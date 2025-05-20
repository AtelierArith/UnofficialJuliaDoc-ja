```
floatmin(T = Float64)
```

Return the smallest positive normal number representable by the floating-point type `T`.

# Examples

```jldoctest
julia> floatmin(Float16)
Float16(6.104e-5)

julia> floatmin(Float32)
1.1754944f-38

julia> floatmin()
2.2250738585072014e-308
```
