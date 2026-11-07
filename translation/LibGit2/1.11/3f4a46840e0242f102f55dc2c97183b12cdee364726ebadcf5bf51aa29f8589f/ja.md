```julia
checkout_index(repo::GitRepo, idx::Union{GitIndex, Nothing} = nothing; options::CheckoutOptions = CheckoutOptions())
```

`repo` の作業ツリーを `idx` に一致するよう更新します。`idx` が `nothing` の場合は、`repo` のインデックスが使用されます。`options` は、チェックアウトの方法を制御します。詳しくは [`CheckoutOptions`](@ref) を参照してください。
