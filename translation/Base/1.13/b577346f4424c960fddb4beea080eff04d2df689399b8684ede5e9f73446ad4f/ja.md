```julia
sign(x)
```

`x==0`および``x/|x|``の場合は0を返し、それ以外の場合（つまり、実数`x`の場合は±1）を返します。

関連項目：[`signbit`](@ref)、[`zero`](@ref)、[`copysign`](@ref)、[`flipsign`](@ref)。

# Examples

```jldoctest
julia> sign(-4.0)
-1.0

julia> sign(99)
1

julia> sign(-0.0)
-0.0

julia> sign(0 + im)
0.0 + 1.0im
```
