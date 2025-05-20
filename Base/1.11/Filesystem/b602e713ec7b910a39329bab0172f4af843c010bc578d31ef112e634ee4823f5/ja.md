```
mktempdir(f::Function, parent=tempdir(); prefix="jl_")
```

関数 `f` を [`mktempdir(parent; prefix)`](@ref) の結果に適用し、完了後に一時ディレクトリとそのすべての内容を削除します。

関連情報: [`mktemp`](@ref), [`mkdir`](@ref)。

!!! compat "Julia 1.2"
    `prefix` キーワード引数は Julia 1.2 で追加されました。

