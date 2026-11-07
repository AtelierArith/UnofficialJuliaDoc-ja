```julia
empty(a::AbstractDict, [index_type=keytype(a)], [value_type=valtype(a)])
```

`index_type` 型のインデックスと、`value_type` 型の値を格納できる、空の `AbstractDict` コンテナーを作成します。第2引数と第3引数は省略可能で、省略した場合はそれぞれ入力の `keytype` と `valtype` が使われます。（2つの型のうち一方だけを指定した場合、もう一方は `value_type` とみなされ、`index_type` の既定値は `keytype(a)` になります。）

カスタム `AbstractDict` サブタイプでは、3引数のシグネチャを特殊化することで、指定されたインデックス型と値型に最適な辞書型を選んで返すことができます。既定では、空の `Dict` を返します。
