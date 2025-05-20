```
checkout_index(repo::GitRepo, idx::Union{GitIndex, Nothing} = nothing; options::CheckoutOptions = CheckoutOptions())
```

`repo`の作業ツリーを`idx`のインデックスに一致させます。`idx`が`nothing`の場合、`repo`のインデックスが使用されます。`options`はチェックアウトの実行方法を制御します。詳細については[`CheckoutOptions`](@ref)を参照してください。
