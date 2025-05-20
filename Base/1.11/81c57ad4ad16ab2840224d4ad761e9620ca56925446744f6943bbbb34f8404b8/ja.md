```
Base.depwarn(msg::String, funcsym::Symbol; force=false)
```

`msg`を非推奨警告として印刷します。シンボル`funcsym`は呼び出し関数の名前であり、各呼び出し場所に対して非推奨警告が最初にのみ印刷されることを保証するために使用されます。`force=true`を設定すると、Juliaが`--depwarn=no`（デフォルト）で起動されていても、警告が常に表示されるようになります。

詳細は[`@deprecate`](@ref)を参照してください。

# 例

```julia
function deprecated_func()
    Base.depwarn("Don't use `deprecated_func()`!", :deprecated_func)

    1 + 1
end
```
