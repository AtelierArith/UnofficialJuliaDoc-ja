```julia
edit(path::AbstractString, line::Integer=0, column::Integer=0)
```

ファイルまたはディレクトリを編集します。ファイルを編集する場合は、行番号を指定することもできます。エディターを終了すると、`julia` プロンプトに戻ります。環境変数 `JULIA_EDITOR`、`VISUAL`、または `EDITOR` を設定すると、使用するエディターを変更できます。

!!! compat "Julia 1.9"
    `column` 引数を使用するには、Julia 1.9 以降が必要です。


関連項目: [`InteractiveUtils.define_editor`](@ref)。
