```
@goto name
```

`@goto name` は、[`@label name`](@ref) の位置にあるステートメントに無条件でジャンプします。

`@label` と `@goto` は、異なるトップレベルのステートメントへのジャンプを作成することはできません。試みるとエラーが発生します。`@goto` を使用するには、`@label` と `@goto` をブロック内に囲む必要があります。
