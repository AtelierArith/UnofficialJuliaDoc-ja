```julia
Base.datatype_arrayelem(dt::DataType)::Int
```

末尾の配列型の割り当て動作を返します。任意の `isconcretetype` に対して呼び出せますが、意味があるのは `Memory` の場合のみです。

0 = inlinealloc 1 = isboxed 2 = isbitsunion
