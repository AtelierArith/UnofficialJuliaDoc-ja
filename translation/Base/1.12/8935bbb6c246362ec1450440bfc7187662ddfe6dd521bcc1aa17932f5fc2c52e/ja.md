```julia
div(x, y, r::RoundingMode=RoundToZero)
```

ユークリッド（整数）除算からの商。`x / y`を計算し、丸めモード`r`に従って整数に丸めます。言い換えれば、数量

```julia
round(x / y, r)
```

を中間的な丸めなしで計算します。

!!! compat "Julia 1.4"
    `RoundingMode`を取る三引数メソッドは、Julia 1.4以降が必要です。


この関数の特別なケースである[`fld`](@ref)および[`cld`](@ref)も参照してください。

!!! compat "Julia 1.9"
    `RoundFromZero`は少なくともJulia 1.9が必要です。


# 例:

```jldoctest
julia> div(4, 3, RoundToZero) # div(4, 3)と一致
1
julia> div(4, 3, RoundDown) # fld(4, 3)と一致
1
julia> div(4, 3, RoundUp) # cld(4, 3)と一致
2
julia> div(5, 2, RoundNearest)
2
julia> div(5, 2, RoundNearestTiesAway)
3
julia> div(-5, 2, RoundNearest)
-2
julia> div(-5, 2, RoundNearestTiesAway)
-3
julia> div(-5, 2, RoundNearestTiesUp)
-2
julia> div(4, 3, RoundFromZero)
2
julia> div(-4, 3, RoundFromZero)
-2
```

`div(x, y)`は浮動小数点数の真の値に基づいて厳密に正しい切り捨て丸めを実装しているため、直感に反する状況が発生することがあります。例えば：

```jldoctest
julia> div(6.0, 0.1)
59.0
julia> 6.0 / 0.1
60.0
julia> 6.0 / big(0.1)
59.99999999999999666933092612453056361837965690217069245739573412231113406246995
```

ここで起こっているのは、`0.1`として書かれた浮動小数点数の真の値が数値的な値1/10よりもわずかに大きく、`6.0`は数値6を正確に表しているためです。したがって、`6.0 / 0.1`の真の値は60未満です。除算を行うと、これは正確に`60.0`に丸められますが、`div(6.0, 0.1, RoundToZero)`は常に真の値を切り捨てるため、結果は`59.0`になります。
