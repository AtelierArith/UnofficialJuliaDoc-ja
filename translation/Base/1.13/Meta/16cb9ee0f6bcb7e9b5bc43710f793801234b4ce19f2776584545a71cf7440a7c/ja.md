```julia
parse(str, start; greedy=true, raise=true, depwarn=true, filename="none")
```

式文字列を解析し、式を返します（返された式は、後で実行するために eval に渡すことができます）。`start` は、解析を開始する最初の文字の `str` 内でのコード単位インデックスです（文字列のインデックス付けでは、通常どおり文字インデックスではありません）。`greedy` が `true`（デフォルト）の場合、`parse` は可能な限り多くの入力を読み取ろうとします。それ以外の場合は、有効な式を解析した時点で停止します。不完全でも、それ以外は構文的に有効な式の場合、`Expr(:incomplete, "(error message)")` を返します。`raise` が `true`（デフォルト）の場合、不完全な式以外の構文エラーはエラーを発生させます。`raise` が `false` の場合、`parse` は、評価時にエラーを発生させる式を返します。`depwarn` が `false` の場合、非推奨警告は抑制されます。エラー発生時に診断情報を表示するには、`filename` 引数を使用します。

```jldoctest
julia> Meta.parse("(α, β) = 3, 5", 1) # start of string
(:((α, β) = (3, 5)), 16)

julia> Meta.parse("(α, β) = 3, 5", 1, greedy=false)
(:((α, β)), 9)

julia> Meta.parse("(α, β) = 3, 5", 16) # end of string
(nothing, 16)

julia> Meta.parse("(α, β) = 3, 5", 11) # index of 3
(:((3, 5)), 16)

julia> Meta.parse("(α, β) = 3, 5", 11, greedy=false)
(3, 13)
```
