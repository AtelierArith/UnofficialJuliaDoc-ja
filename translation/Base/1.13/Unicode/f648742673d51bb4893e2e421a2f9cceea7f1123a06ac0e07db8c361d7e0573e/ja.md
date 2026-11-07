```julia
isletter(c::AbstractChar)::Bool
```

文字が文字（letter）かどうかを判定します。Unicode の一般カテゴリで Letter に属する文字、つまりカテゴリコードが「L」で始まる文字は、文字として分類されます。

関連項目: [`isdigit`](@ref)。

# Examples

```jldoctest
julia> isletter('❤')
false

julia> isletter('α')
true

julia> isletter('9')
false
```
