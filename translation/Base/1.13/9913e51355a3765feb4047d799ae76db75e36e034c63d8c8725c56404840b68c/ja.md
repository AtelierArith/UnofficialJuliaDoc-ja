```julia
@goto name
```

`@goto name` は、[`@label name`](@ref) の位置にある文へ無条件にジャンプします。

`@label` と `@goto` では、別のトップレベル文へジャンプできません。そのようにしようとするとエラーになります。それでも `@goto` を使うには、`@label` と `@goto` をブロックで囲みます。
