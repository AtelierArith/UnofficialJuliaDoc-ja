```
chop(s::AbstractString; head::Integer = 0, tail::Integer = 1)
```

`s`の最初の`head`文字と最後の`tail`文字を削除します。呼び出し`chop(s)`は`s`の最後の文字を削除します。`length(s)`よりも多くの文字を削除するように要求された場合、空の文字列が返されます。

関連項目としては[`chomp`](@ref)、[`startswith`](@ref)、[`first`](@ref)があります。

# 例

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
