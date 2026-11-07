```julia
div(x, y, r::RoundingMode=RoundToZero)
```

ユークリッド（整数）除算による商です。`x / y`を、丸めモード`r`に従って整数に丸めて計算します。つまり、次の量を

```julia
round(x / y, r)
```

中間丸めを行わずに計算します。

!!! compat "Julia 1.4"
    `RoundingMode`を受け取る3引数メソッドは、Julia 1.4以降で利用できます。


この関数の特殊なケースである[`fld`](@ref)および[`cld`](@ref)も参照してください。

!!! compat "Julia 1.9"
    `RoundFromZero`はJulia 1.9以降で利用できます。


# Examples:

```jldoctest
julia> div(4, 3, RoundToZero) # Matches div(4, 3)
1
julia> div(4, 3, RoundDown) # Matches fld(4, 3)
1
julia> div(4, 3, RoundUp) # Matches cld(4, 3)
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

`div(x, y)`は、浮動小数点数の真の値に基づいて厳密に正しい切り捨てを行うため、直感に反する結果になることがあります。たとえば、次のようになります。

```jldoctest
julia> div(6.0, 0.1)
59.0
julia> 6.0 / 0.1
60.0
julia> 6.0 / big(0.1)
59.99999999999999666933092612453056361837965690217069245739573412231113406246995
```

ここで起きているのは、`0.1`と表記される浮動小数点数の真の値が数値1/10よりわずかに大きい一方、`6.0`は数値6を正確に表しているということです。そのため、`6.0 / 0.1`の真の値は60よりわずかに小さくなります。除算時にはこれがちょうど`60.0`に丸められますが、`div(6.0, 0.1, RoundToZero)`は常に真の値を切り捨てるため、結果は`59.0`になります。
