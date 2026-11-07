```julia
method_table(interp::AbstractInterpreter)::MethodTableView
```

この `interp` がメソッドの検索に使用するメソッドテーブルを返します。外部の `AbstractInterpreter` は、オーバーライドされたメソッドのカスタムディスパッチを組み込むために、ここで `OverlayMethodTable` を返すこともできます。
