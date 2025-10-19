```julia
isuppercase(c::AbstractChar) -> Bool
```

文字が大文字のアルファベットであるかどうかをテストします（Unicode標準の`Uppercase`派生プロパティに従います）。

関連項目として[`islowercase`](@ref)があります。

# 例

```jldoctest
julia> isuppercase('γ')
false

julia> isuppercase('Γ')
true

julia> isuppercase('❤')
false
```
