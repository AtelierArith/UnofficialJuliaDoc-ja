```julia
divrem(x, y, r::RoundingMode=RoundToZero)
```

ユークリッド除法による商と余り。`(div(x, y, r), rem(x, y, r))`と同等です。`r`のデフォルト値を使う場合、この呼び出しは`(x ÷ y, x % y)`と同等です。

関連項目: [`fldmod`](@ref)、[`cld`](@ref)。

# Examples

```jldoctest
julia> divrem(3, 7)
(0, 3)

julia> divrem(7, 3)
(2, 1)
```
