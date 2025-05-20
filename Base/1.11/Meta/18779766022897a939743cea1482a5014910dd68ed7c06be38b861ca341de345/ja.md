```
parse(str; raise=true, depwarn=true, filename="none")
```

式の文字列を貪欲に解析し、単一の式を返します。最初の式の後に追加の文字がある場合はエラーがスローされます。`raise`が`true`（デフォルト）である場合、構文エラーはエラーをスローします。そうでない場合、`parse`は評価時にエラーをスローする式を返します。`depwarn`が`false`の場合、非推奨警告は抑制されます。`filename`引数は、エラーが発生したときに診断を表示するために使用されます。

```jldoctest; filter=r"(?<=Expr\(:error).*|(?<=Expr\(:incomplete).*"
julia> Meta.parse("x = 3")
:(x = 3)

julia> Meta.parse("1.0.2")
ERROR: ParseError:
# Error @ none:1:1
1.0.2
└──┘ ── 無効な数値定数
[...]

julia> Meta.parse("1.0.2"; raise = false)
:($(Expr(:error, "無効な数値定数 "1.0."")))

julia> Meta.parse("x = ")
:($(Expr(:incomplete, "不完全: 入力の早期終了")))
```
