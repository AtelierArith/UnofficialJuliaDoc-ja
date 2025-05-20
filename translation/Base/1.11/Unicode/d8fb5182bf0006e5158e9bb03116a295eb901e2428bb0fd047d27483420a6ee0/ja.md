```
isuppercase(c::AbstractChar) -> Bool
```

文字が大文字のアルファベットであるかどうかをテストします（Unicode標準の`Uppercase`派生プロパティに従います）。

関連情報として[`islowercase`](@ref)も参照してください。

# 例

```jldoctest
julia> isuppercase('γ')
false

julia> isuppercase('Γ')
true

julia> isuppercase('❤')
false
```
