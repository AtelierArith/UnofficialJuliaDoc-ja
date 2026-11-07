```julia
Meta.unblock(expr)
```

冗長なブロック式を取り除きます。

具体的には、この関数は次の式を削除します。

  * 行番号以外の引数を1つだけ持つ `:block` 式。
  * `:var"hygienic-scope"` / `:escape` 式のペア。
