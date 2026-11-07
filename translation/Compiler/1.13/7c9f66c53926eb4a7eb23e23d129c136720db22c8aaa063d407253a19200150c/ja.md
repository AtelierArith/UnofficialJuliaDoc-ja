```julia
method_table(interp::AbstractInterpreter)::MethodTableView
```

この`interp`がメソッドの検索に使用するメソッドテーブルを返します。外部の`AbstractInterpreter`は、オーバーライドされたメソッドにカスタマイズしたディスパッチを組み込むため、必要に応じてここで`OverlayMethodTable`を返すことができます。
