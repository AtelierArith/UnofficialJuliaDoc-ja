```
islowercase(c::AbstractChar) -> Bool
```

文字が小文字であるかどうかをテストします（Unicode標準の`Lowercase`派生プロパティに従います）。

関連情報として[`isuppercase`](@ref)も参照してください。

# 例

```jldoctest
julia> islowercase('α')
true

julia> islowercase('Γ')
false

julia> islowercase('❤')
false
```
