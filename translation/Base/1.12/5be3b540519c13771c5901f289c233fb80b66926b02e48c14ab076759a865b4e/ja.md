```julia
cld(x, y)
```

`x / y`以上の最小の整数。`div(x, y, RoundUp)`と同等です。

他にも[`div`](@ref)、[`fld`](@ref)を参照してください。

# 例

```jldoctest
julia> cld(5.5, 2.2)
3.0

julia> cld.(-5:5, 3)'
1×11 adjoint(::Vector{Int64}) with eltype Int64:
 -1  -1  -1  0  0  0  1  1  1  2  2
```
