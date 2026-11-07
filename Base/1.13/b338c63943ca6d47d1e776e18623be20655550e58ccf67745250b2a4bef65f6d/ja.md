```julia
Base.datatype_pointerfree(dt::DataType)::Bool
```

この型のインスタンスが、GC 管理メモリへの参照を含む可能性があるかどうかを返します。任意の `isconcretetype` に対して呼び出せます。
