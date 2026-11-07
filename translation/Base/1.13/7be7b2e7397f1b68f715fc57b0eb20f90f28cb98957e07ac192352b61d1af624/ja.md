```julia
Base.datatype_haspadding(dt::DataType)::Bool
```

この型のインスタンスのフィールドが、間にパディングビット（インスタンス自体の意味上の値に影響しないビット）を挟まずにメモリ上に詰めて配置されているかどうかを返します。任意の`isconcretetype`に対して呼び出せます。
