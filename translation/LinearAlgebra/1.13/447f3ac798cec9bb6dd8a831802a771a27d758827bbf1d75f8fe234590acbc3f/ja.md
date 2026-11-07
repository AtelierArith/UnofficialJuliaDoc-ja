```julia
svd!(A, B) -> GeneralizedSVD
```

`svd!`は[`svd`](@ref)と同じですが、コピーを作成する代わりに、引数`A`および`B`をその場で変更します。詳細は[`svd`](@ref)のドキュメントを参照してください。
