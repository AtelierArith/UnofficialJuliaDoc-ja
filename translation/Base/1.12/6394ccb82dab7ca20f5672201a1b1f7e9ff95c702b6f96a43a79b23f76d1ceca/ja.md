```julia
sign(x)
```

`x==0` の場合はゼロを返し、それ以外の場合は $x/|x|$ を返します（すなわち、実数 `x` に対して ±1）。

関連項目としては [`signbit`](@ref), [`zero`](@ref), [`copysign`](@ref), [`flipsign`](@ref) があります。

# 例

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
