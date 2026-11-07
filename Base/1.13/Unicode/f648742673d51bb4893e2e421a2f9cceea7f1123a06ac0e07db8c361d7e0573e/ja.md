```julia
isletter(c::AbstractChar)::Bool
```

文字が文字（letter）かどうかを判定します。Unicodeの一般カテゴリでLetterに分類される文字、つまりカテゴリコードが「L」で始まる文字は、文字と判定されます。

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
