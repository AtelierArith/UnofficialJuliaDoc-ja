```julia
parse(str; raise=true, depwarn=true, filename="none")
```

式文字列を貪欲に解析し、単一の式を返します。最初の式の後に文字が残っている場合はエラーが発生します。`raise` が `true`（デフォルト）の場合、構文エラーが発生するとエラーになります。それ以外の場合、`parse` は、評価時にエラーを発生させる式を返します。`depwarn` が `false` の場合、非推奨警告は抑制されます。エラー発生時に診断情報を表示するには、`filename` 引数を使用します。

```jldoctest; filter=r"(?<=Expr\(:error).*|(?<=Expr\(:incomplete).*"
julia> Meta.parse("x = 3")
:(x = 3)

julia> Meta.parse("1.0.2")
ERROR: ParseError:
# Error @ none:1:1
1.0.2
└──┘ ── invalid numeric constant
[...]

julia> Meta.parse("1.0.2"; raise = false)
:($(Expr(:error, "invalid numeric constant "1.0."")))

julia> Meta.parse("x = ")
:($(Expr(:incomplete, "incomplete: premature end of input")))
```
