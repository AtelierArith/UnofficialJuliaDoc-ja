```julia
Base.datatype_nfields(dt::DataType)::UInt32
```

このデータ型のレイアウトで認識されているフィールド数を返します。不透明型の場合、実際の型のフィールド数とは異なることがあります。任意の`isconcretetype`に対して呼び出せます。
