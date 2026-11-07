```julia
unindent(str::AbstractString, indent::Int; tabwidth=8)
```

文字列の先頭のインデントを削除します。

`indent` については、[`MultilineStrings` package](https://github.com/invenia/MultilineStrings.jl) を参照してください。

# Examples

```jldoctest
julia> Base.unindent("   a\n   b", 2)
" a\n b"

julia> Base.unindent("\ta\n\tb", 2, tabwidth=8)
"      a\n      b"
```
