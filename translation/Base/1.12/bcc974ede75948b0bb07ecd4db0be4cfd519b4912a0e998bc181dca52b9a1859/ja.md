```julia
divrem(x, y, r::RoundingMode=RoundToZero)
```

ユークリッド除算からの商と余り。`(div(x, y, r), rem(x, y, r))`と同等です。同様に、`r`のデフォルト値を使用した場合、この呼び出しは`(x ÷ y, x % y)`と同等です。

参照: [`fldmod`](@ref), [`cld`](@ref)。

# 例

```jldoctest
julia> divrem(3, 7)
(0, 3)

julia> divrem(7, 3)
(2, 1)
```
