```julia
Base.datatype_haspadding(dt::DataType)::Bool
```

この型のインスタンスのフィールドが、メモリ上で隙間なく配置されているかどうかを返します。ここでいう隙間とは、インスタンス自体の意味上の値に影響しないビットを指します。任意の`isconcretetype`に対して呼び出せます。
