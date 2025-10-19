```julia
edit(path::AbstractString, line::Integer=0, column::Integer=0)
```

ファイルまたはディレクトリを編集し、オプションでファイルを編集する行番号を指定します。エディタを終了すると、`julia` プロンプトに戻ります。エディタは、環境変数として `JULIA_EDITOR`、`VISUAL` または `EDITOR` を設定することで変更できます。

!!! compat "Julia 1.9"
    `column` 引数は少なくとも Julia 1.9 が必要です。


他にも [`InteractiveUtils.define_editor`](@ref) を参照してください。
