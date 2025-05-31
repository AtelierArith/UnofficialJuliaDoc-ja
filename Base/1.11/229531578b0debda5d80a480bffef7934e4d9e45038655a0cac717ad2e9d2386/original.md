```
findlast(pattern::AbstractVector{<:Union{Int8,UInt8}},
         A::AbstractVector{<:Union{Int8,UInt8}})
```

Find the last occurrence of `pattern` in array `A`. Equivalent to [`findprev(pattern, A, lastindex(A))`](@ref).

# Examples

```jldoctest
julia> findlast([0x52, 0x62], [0x52, 0x62, 0x52, 0x62])
3:4
```
