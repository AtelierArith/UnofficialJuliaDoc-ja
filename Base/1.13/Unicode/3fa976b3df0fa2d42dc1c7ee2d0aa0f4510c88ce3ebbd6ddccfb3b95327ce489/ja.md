```julia
isuppercase(c::AbstractChar)::Bool
```

文字が大文字かどうかを判定します（Unicode 標準の `Uppercase` 派生プロパティに基づきます）。

[`islowercase`](@ref) も参照してください。

# Examples

```jldoctest
julia> isuppercase('γ')
false

julia> isuppercase('Γ')
true

julia> isuppercase('❤')
false
```
