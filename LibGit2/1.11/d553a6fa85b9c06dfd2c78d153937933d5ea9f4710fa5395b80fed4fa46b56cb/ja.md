```
checkout_tree(repo::GitRepo, obj::GitObject; options::CheckoutOptions = CheckoutOptions())
```

`repo`の作業ツリーとインデックスを`obj`が指すツリーに一致させます。`obj`はコミット、タグ、またはツリーである可能性があります。`options`はチェックアウトがどのように行われるかを制御します。詳細については[`CheckoutOptions`](@ref)を参照してください。
