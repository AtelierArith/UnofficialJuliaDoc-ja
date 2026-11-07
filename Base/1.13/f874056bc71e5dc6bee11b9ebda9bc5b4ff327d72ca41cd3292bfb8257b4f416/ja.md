```julia
Base.depwarn(msg::String, funcsym::Symbol; force=false)
```

`msg` を非推奨警告として出力します。シンボル `funcsym` には呼び出し元の関数名を指定します。これは、呼び出し箇所ごとに最初の1回だけ非推奨警告を出力するために使われます。`force=true` を設定すると、Julia の起動時に `--depwarn=no`（デフォルト）が指定されていても、警告が常に表示されます。

[`@deprecate`](@ref) を参照してください。

# Examples

```julia
function deprecated_func()
    Base.depwarn("Don't use `deprecated_func()`!", :deprecated_func)

    1 + 1
end
```
