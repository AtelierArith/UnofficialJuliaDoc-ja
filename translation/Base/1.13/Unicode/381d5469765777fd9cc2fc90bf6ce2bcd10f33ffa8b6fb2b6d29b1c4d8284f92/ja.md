```julia
islowercase(c::AbstractChar)::Bool
```

文字が小文字かどうかを判定します（Unicode 標準の `Lowercase` 派生プロパティに基づきます）。

[`isuppercase`](@ref) も参照してください。

# Examples

```jldoctest
julia> islowercase('α')
true

julia> islowercase('Γ')
false

julia> islowercase('❤')
false
```
