```julia
Base.datatype_alignment(dt::DataType)::Int
```

この型のインスタンスに必要なメモリ割り当ての最小アラインメント。任意の`isconcretetype`に対して呼び出せますが、Memoryの場合はオブジェクト全体ではなく、要素のアラインメントが返されます。
