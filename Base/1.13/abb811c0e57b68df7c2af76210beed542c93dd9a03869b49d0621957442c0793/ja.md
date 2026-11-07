```julia
chop(s::AbstractString; head::Integer = 0, tail::Integer = 1)
```

`s` から先頭の `head` 文字と末尾の `tail` 文字を削除します。`chop(s)` を呼び出すと、`s` の末尾の文字が削除されます。`length(s)` より多くの文字を削除するよう指定した場合は、空文字列が返されます。

関連項目: [`chomp`](@ref)、[`startswith`](@ref)、[`first`](@ref)。

# Examples

```jldoctest
julia> a = "March"
"March"

julia> chop(a)
"Marc"

julia> chop(a, head = 1, tail = 2)
"ar"

julia> chop(a, head = 5, tail = 5)
""
```
