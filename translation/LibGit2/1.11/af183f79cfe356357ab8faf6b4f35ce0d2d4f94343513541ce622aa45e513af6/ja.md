```julia
checkout_tree(repo::GitRepo, obj::GitObject; options::CheckoutOptions = CheckoutOptions())
```

`repo` の作業ツリーとインデックスを、`obj` が指すツリーと一致するように更新します。`obj` には、コミット、タグ、またはツリーを指定できます。`options` は、チェックアウトの方法を制御します。詳しくは [`CheckoutOptions`](@ref) を参照してください。
