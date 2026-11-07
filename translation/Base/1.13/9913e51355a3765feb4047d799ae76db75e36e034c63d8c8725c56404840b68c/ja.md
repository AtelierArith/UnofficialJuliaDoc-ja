```julia
@goto name
```

`@goto name` は、[`@label name`](@ref) の位置にある文へ無条件にジャンプします。

`@label` と `@goto` では、異なるトップレベルの文へのジャンプを作成できません。これを試みるとエラーになります。それでも `@goto` を使用するには、`@label` と `@goto` をブロックで囲みます。
