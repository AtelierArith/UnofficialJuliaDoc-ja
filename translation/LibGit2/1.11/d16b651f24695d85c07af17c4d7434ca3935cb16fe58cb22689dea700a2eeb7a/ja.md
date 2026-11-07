```julia
checkout_head(repo::GitRepo; options::CheckoutOptions = CheckoutOptions())
```

`repo` のインデックスと作業ツリーを、HEAD が指すコミットの状態に更新します。チェックアウトの方法は `options` で制御します。詳しくは [`CheckoutOptions`](@ref) を参照してください。

!!! warning
    ブランチの切り替えにこの関数を*使用しないでください*。チェックアウトの競合が発生します。

