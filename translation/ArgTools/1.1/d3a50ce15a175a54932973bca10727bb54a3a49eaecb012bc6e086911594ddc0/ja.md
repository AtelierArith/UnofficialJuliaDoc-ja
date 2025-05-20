```
ArgWrite = Union{AbstractString, AbstractCmd, IO}
```

`ArgWrite` タイプは、`arg_write` 関数が書き込み可能な IO ハンドルに変換する方法を知っているタイプのユニオンであり、`Nothing` は `arg_write` が一時ファイルを生成することで処理します。詳細については [`arg_write`](@ref) を参照してください。
