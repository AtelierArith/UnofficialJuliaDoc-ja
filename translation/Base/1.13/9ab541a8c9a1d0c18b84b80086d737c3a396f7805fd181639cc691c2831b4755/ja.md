```julia
Base.datatype_fielddesc_type(dt::DataType)::Int
```

レイアウト配列 `(dt.layout + sizeof(DataTypeLayout))` 内の各フィールド記述エントリのサイズをバイト単位で返します。任意の `isconcretetype` に対して呼び出せます。

[`fieldoffset`](@ref)。
