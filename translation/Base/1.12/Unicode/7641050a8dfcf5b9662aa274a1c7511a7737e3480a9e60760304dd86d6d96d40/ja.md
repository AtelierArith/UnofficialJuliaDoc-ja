```julia
isletter(c::AbstractChar) -> Bool
```

文字が文字であるかどうかをテストします。文字は、Unicodeの一般カテゴリ「Letter」に属する場合、すなわちカテゴリコードが「L」で始まる文字として分類されます。

参照: [`isdigit`](@ref)。

# 例

```jldoctest
julia> isletter('❤')
false

julia> isletter('α')
true

julia> isletter('9')
false
```
