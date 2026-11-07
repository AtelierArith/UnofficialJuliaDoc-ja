```julia
isnumeric(c::AbstractChar)::Bool
```

文字が数値かどうかを判定します。Unicode の一般カテゴリ Number に属する文字、つまりカテゴリコードが「N」で始まる文字は、数値と判定されます。

この広いカテゴリには、¾ や ௰ などの文字も含まれます。文字が 0 から 9 までの十進数字かどうかを調べるには、[`isdigit`](@ref) を使用してください。

# Examples

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
