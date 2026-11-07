```julia
svd!(A, B) -> GeneralizedSVD
```

`svd!`は[`svd`](@ref)と同じですが、コピーを作成するのではなく、引数`A`と`B`をその場で変更します。詳細は[`svd`](@ref)のドキュメントを参照してください。
