```julia
islowercase(c::AbstractChar) -> Bool
```

文字が小文字であるかどうかをテストします（Unicode標準の`Lowercase`派生プロパティに従います）。

関連項目として[`isuppercase`](@ref)があります。

# 例

```jldoctest
julia> islowercase('α')
true

julia> islowercase('Γ')
false

julia> islowercase('❤')
false
```
