```julia
mod(x, y)
rem(x, y, RoundDown)
```

`x`を`y`で切り下げ除算したときの余り。つまり、`x`を`y`で割った余りであり、中間で丸めを行わずに計算した場合は`x - y*fld(x,y)`となる。

結果の符号は、`isfinite(y)`の場合、`y`と同じになり、絶対値は`abs(y)`より小さくなる（例外については下記の注を参照）。

!!! note
    浮動小数点値に対して使用すると、厳密な結果をその型で表現できない場合があり、丸め誤差が生じることがあります。特に、厳密な結果が`y`に非常に近い場合、`y`に丸められることがあります。


関連項目: [`rem`](@ref)、[`div`](@ref)、[`fld`](@ref)、[`mod1`](@ref)、[`invmod`](@ref)。

```jldoctest
julia> mod(8, 3)
2

julia> mod(9, 3)
0

julia> mod(8.9, 3)
2.9000000000000004

julia> mod(eps(), 3)
2.220446049250313e-16

julia> mod(-eps(), 3)
3.0

julia> mod.(-5:5, 3)'
1×11 adjoint(::Vector{Int64}) with eltype Int64:
 1  2  0  1  2  0  1  2  0  1  2
```
