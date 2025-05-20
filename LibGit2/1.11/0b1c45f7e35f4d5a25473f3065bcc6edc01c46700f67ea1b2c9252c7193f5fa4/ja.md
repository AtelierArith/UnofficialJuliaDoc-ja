```
checkout_head(repo::GitRepo; options::CheckoutOptions = CheckoutOptions())
```

`repo`のインデックスと作業ツリーをHEADが指すコミットに一致させます。`options`はチェックアウトがどのように行われるかを制御します。詳細については[`CheckoutOptions`](@ref)を参照してください。

!!! warning
    *この関数を使用してブランチを切り替えないでください！そうするとチェックアウトの競合が発生します。

