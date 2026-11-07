```julia
chomp(s::AbstractString)::SubString
```

文字列の末尾にある改行を1つ（つまり「\r\n」または「\n」）削除します。

関連項目：[`chop`](@ref)。

# Examples

```jldoctest
julia> chomp("Hello\n")
"Hello"

julia> chomp("World\r\n")
"World"

julia> chomp("Julia\r\n\n")
"Julia\r\n"
```
