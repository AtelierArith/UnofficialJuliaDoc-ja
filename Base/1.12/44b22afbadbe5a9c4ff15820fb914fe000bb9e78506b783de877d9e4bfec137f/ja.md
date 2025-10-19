```julia
Base.datatype_alignment(dt::DataType) -> Int
```

この型のインスタンスのメモリアロケーションの最小アライメント。`isconcretetype`の任意の型に対して呼び出すことができますが、Memoryの場合はオブジェクト全体ではなく要素のアライメントを返します。
