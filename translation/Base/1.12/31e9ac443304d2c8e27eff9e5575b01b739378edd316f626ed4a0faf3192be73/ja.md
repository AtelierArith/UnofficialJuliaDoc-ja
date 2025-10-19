```julia
chomp(s::AbstractString) -> SubString
```

文字列から末尾の改行を1つ削除します。

関連項目 [`chop`](@ref)。

# 例

```jldoctest
julia> chomp("Hello\n")
"Hello"
```
