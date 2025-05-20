```
div(x, y, r::RoundingMode=RoundToZero)
```

ユークリッド（整数）除算からの商。`x / y`を計算し、丸めモード`r`に従って整数に丸めます。言い換えれば、量は

```
round(x / y, r)
```

中間的な丸めなしで。

!!! compat "Julia 1.4"
    `RoundingMode`を取る三引数メソッドは、Julia 1.4以降が必要です。


他に[`fld`](@ref)や[`cld`](@ref)も参照してください。これらはこの関数の特別なケースです。

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
