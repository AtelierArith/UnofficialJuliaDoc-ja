```
rem(x, y, r::RoundingMode=RoundToZero)
```

`y`で整数除算した後の`x`の余りを計算します。商は丸めモード`r`に従って丸められます。言い換えれば、量は

```
x - y * round(x / y, r)
```

中間の丸めなしで計算されます。

  * `r == RoundNearest`の場合、結果は正確で、区間$[-|y| / 2, |y| / 2]$にあります。詳細は[`RoundNearest`](@ref)を参照してください。
  * `r == RoundToZero`（デフォルト）の場合、結果は正確で、`x`が正の場合は区間$[0, |y|)$、それ以外の場合は$(-|y|, 0]$にあります。詳細は[`RoundToZero`](@ref)を参照してください。
  * `r == RoundDown`の場合、結果は`y`が正の場合は区間$[0, y)$、それ以外の場合は$(y, 0]$にあります。`x`と`y`の符号が異なり、`abs(x) < abs(y)`の場合、結果は正確でない可能性があります。詳細は[`RoundDown`](@ref)を参照してください。
  * `r == RoundUp`の場合、結果は`y`が正の場合は区間$(-y, 0]$、それ以外の場合は$[0, -y)$にあります。`x`と`y`の符号が同じで、`abs(x) < abs(y)`の場合、結果は正確でない可能性があります。詳細は[`RoundUp`](@ref)を参照してください。
  * `r == RoundFromZero`の場合、結果は`y`が正の場合は区間$(-y, 0]$、それ以外の場合は$[0, -y)$にあります。`x`と`y`の符号が同じで、`abs(x) < abs(y)`の場合、結果は正確でない可能性があります。詳細は[`RoundFromZero`](@ref)を参照してください。

!!! compat "Julia 1.9"
    `RoundFromZero`は少なくともJulia 1.9が必要です。


# 例:

```jldoctest
julia> x = 9; y = 4;

julia> x % y  # rem(x, y)と同じ
1

julia> x ÷ y  # div(x, y)と同じ
2

julia> x == div(x, y) * y + rem(x, y)
true
```
