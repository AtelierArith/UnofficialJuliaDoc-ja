```julia
isnumeric(c::AbstractChar) -> Bool
```

文字が数値であるかどうかをテストします。文字は、Unicodeの一般カテゴリ「Number」に属する場合、すなわちカテゴリコードが'N'で始まる文字として分類されます。

この広いカテゴリには、¾や௰のような文字が含まれます。文字が0から9の間の10進数の数字であるかどうかを確認するには、[`isdigit`](@ref)を使用してください。

# 例

```jldoctest
julia> isnumeric('௰')
true

julia> isnumeric('9')
true

julia> isnumeric('α')
false

julia> isnumeric('❤')
false
```
