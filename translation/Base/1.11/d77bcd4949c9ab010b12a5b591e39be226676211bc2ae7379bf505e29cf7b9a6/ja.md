```
repeat(s::AbstractString, r::Integer)
```

文字列を `r` 回繰り返します。これは `s^r` として書くことができます。

関連項目 [`^`](@ref :^(::Union{AbstractString, AbstractChar}, ::Integer))。

# 例

```jldoctest
julia> repeat("ha", 3)
"hahaha"
```
