```julia
empty(a::AbstractDict, [index_type=keytype(a)], [value_type=valtype(a)])
```

空の `AbstractDict` コンテナを作成し、`index_type` 型のインデックスと `value_type` 型の値を受け入れることができます。第二および第三の引数はオプションで、入力の `keytype` と `valtype` にそれぞれデフォルト設定されています。（2つの型のうち1つだけが指定された場合、それは `value_type` と見なされ、`index_type` は `keytype(a)` にデフォルト設定されます）。

カスタム `AbstractDict` サブタイプは、与えられたインデックスおよび値の型に最適な辞書型を返すために、3引数のシグネチャに特化することができます。デフォルトは空の `Dict` を返すことです。
