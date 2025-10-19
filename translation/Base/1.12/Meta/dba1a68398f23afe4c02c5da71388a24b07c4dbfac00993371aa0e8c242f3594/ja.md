```julia
parse(str, start; greedy=true, raise=true, depwarn=true, filename="none")
```

式の文字列を解析し、式を返します（これは後でevalに渡して実行することができます）。`start`は、解析を開始する最初の文字の`str`内のコードユニットインデックスです（すべての文字列インデックスと同様に、これは文字インデックスではありません）。`greedy`が`true`（デフォルト）の場合、`parse`はできるだけ多くの入力を消費しようとします。そうでない場合、有効な式を解析した時点で停止します。未完成だがそれ以外は構文的に有効な式は、`Expr(:incomplete, "(エラーメッセージ)")`を返します。`raise`が`true`（デフォルト）の場合、未完成の式以外の構文エラーはエラーを発生させます。`raise`が`false`の場合、`parse`は評価時にエラーを発生させる式を返します。`depwarn`が`false`の場合、非推奨警告は抑制されます。`filename`引数は、エラーが発生したときに診断を表示するために使用されます。

```jldoctest
julia> Meta.parse("(α, β) = 3, 5", 1) # 文字列の開始
(:((α, β) = (3, 5)), 16)

julia> Meta.parse("(α, β) = 3, 5", 1, greedy=false)
(:((α, β)), 9)

julia> Meta.parse("(α, β) = 3, 5", 16) # 文字列の終わり
(nothing, 16)

julia> Meta.parse("(α, β) = 3, 5", 11) # 3のインデックス
(:((3, 5)), 16)

julia> Meta.parse("(α, β) = 3, 5", 11, greedy=false)
(3, 13)
```
