```julia
Base.depwarn(msg::String, funcsym::Symbol; force=false)
```

`msg` を非推奨警告として出力します。シンボル `funcsym` には呼び出し元の関数名を指定します。これにより、呼び出し箇所ごとに初回のみ非推奨警告が出力されます。Julia の起動時に `--depwarn=no`（デフォルト）が指定されていても、常に警告を表示するには `force=true` を設定します。

関連項目: [`@deprecate`](@ref)。

# Examples

```julia
function deprecated_func()
    Base.depwarn("Don't use `deprecated_func()`!", :deprecated_func)

    1 + 1
end
```
