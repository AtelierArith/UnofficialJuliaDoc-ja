```
Base.datatype_pointerfree(dt::DataType) -> Bool
```

この型のインスタンスがガベージコレクション管理メモリへの参照を含むことができるかどうかを返します。`isconcretetype` の任意のものに対して呼び出すことができます。
